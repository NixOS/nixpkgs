#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts coreutils gawk replace
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

nixpkgs=../../../..
repo=https://github.com/be5invis/Iosevka

# Discover the latest version.
current_version=$(nix-instantiate "$nixpkgs" --eval --strict -A iosevka.version | tr -d '"')
new_version=$(list-git-tags --url="$repo" | sort --reverse --version-sort | awk 'match($0, /^v([0-9.]+)$/, m) { print m[1]; exit; }')
if [[ "$new_version" == "$current_version" ]]; then
    echo "iosevka: no update found"
    exit
fi

# Update the source package in nodePackages.
current_source="$repo/archive/v$current_version.tar.gz"
new_source="$repo/archive/v$new_version.tar.gz"
replace-literal -ef "$current_source" "$new_source" ../../../development/node-packages/node-packages.json
echo "iosevka: $current_version -> $new_version (after nodePackages update)"
