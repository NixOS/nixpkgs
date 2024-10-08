#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts

set -eou pipefail

PACKAGE_PATH=./pkgs/by-name/ze/zen-browser-unwrapped
PACKAGE_NIX="$PACKAGE_PATH"/package.nix

version="$(curl --silent 'https://api.github.com/repos/zen-browser/desktop/releases/latest' | jq --raw-output '.tag_name')"
update-source-version zen-browser-unwrapped "${version}" --file="$PACKAGE_NIX"

# Get the extracted src for zen-browser, we need to read the `surfer.json` file
# to get the Firefox version.
src="$(nix-build -A zen-browser-unwrapped.src --no-out-link)"

# Get the Firefox version from the `surfer.json` file.
firefoxVersion=$(cat "$src"/surfer.json | jq --raw-output '.version.version')

# Update the Firefox version for the derivation.
update-source-version zen-browser-unwrapped "$firefoxVersion" --version-key=firefoxVersion --source-key=firefoxSrc --file="$PACKAGE_NIX"
