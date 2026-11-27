#!/usr/bin/env bash
# Install the Zed themes from this repo into Zed's themes directory.
#
# Usage: ./install.sh [--link]
#   --link   symlink the theme files instead of copying them,
#            so a `git pull` updates the installed themes.

set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
themes_dir="${XDG_CONFIG_HOME:-$HOME/.config}/zed/themes"

mode="copy"
case "${1:-}" in
    "") ;;
    --link) mode="link" ;;
    -h|--help)
        sed -n '2,7p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
        exit 0
        ;;
    *)
        echo "Unknown option: $1 (see --help)" >&2
        exit 1
        ;;
esac

shopt -s nullglob
themes=("$repo_dir"/*.json)
if [ ${#themes[@]} -eq 0 ]; then
    echo "No theme files (*.json) found in $repo_dir" >&2
    exit 1
fi

mkdir -p "$themes_dir"

for theme in "${themes[@]}"; do
    name="$(basename "$theme")"
    if [ "$mode" = "link" ]; then
        ln -sfn "$theme" "$themes_dir/$name"
        echo "Linked $name -> $themes_dir/$name"
    else
        # Remove first so an existing symlink is replaced, not written through.
        rm -f "$themes_dir/$name"
        cp "$theme" "$themes_dir/$name"
        echo "Copied $name -> $themes_dir/$name"
    fi
done

echo "Done. Pick a theme in Zed with: theme selector: toggle (Ctrl+K Ctrl+T)."
