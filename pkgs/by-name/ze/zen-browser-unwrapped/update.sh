#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts curl jq nix-update

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/../../../.."
packageFile=pkgs/by-name/ze/zen-browser-unwrapped/package.nix
attribute=zen-browser-unwrapped

version=$(curl --fail --silent --show-error \
  https://api.github.com/repos/zen-browser/desktop/releases/latest | jq -er .tag_name)
currentVersion=$(nix eval --raw -f . "$attribute.version")

if [[ "$version" == "$currentVersion" ]]; then
  echo "Zen Browser is already at $version"
  exit 0
fi

update-source-version "$attribute" "$version" \
  --source-key=zenSource --file="$packageFile"

sourcePath=$(nix-build --no-out-link -A "$attribute.zenSource")
firefoxVersion=$(jq -er .version.version "$sourcePath/surfer.json")

update-source-version "$attribute" "$firefoxVersion" \
  --version-key=firefoxVersion --source-key=firefoxSource --file="$packageFile"

nix-update --version=skip --no-src --override-filename "$packageFile" "$attribute.ffprefs"
nix-update --version=skip --no-src --override-filename "$packageFile" "$attribute.src"
