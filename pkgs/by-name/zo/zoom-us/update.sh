#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts curl jq

set -eu -o pipefail

scriptDir=$(cd "${BASH_SOURCE[0]%/*}" && pwd)
nixpkgs=$(realpath "$scriptDir"/../../../..)

echo >&2 "=== Obtaining version data from https://zoom.us/rest/download ..."
linux_data=$(curl -Ls 'https://zoom.us/rest/download?os=linux' | jq .result.downloadVO)
mac_data=$(curl -Ls 'https://zoom.us/rest/download?os=mac' | jq .result.downloadVO)

version_aarch64_darwin=$(jq -r .zoomArm64.version <<<"$mac_data")
version_x86_64_darwin=$(jq -r .zoom.version <<<"$mac_data")
version_x86_64_linux=$(jq -r .zoom.version <<<"$linux_data")

echo >&2 "=== Updating package.nix ..."
# update-source-version expects to be at the root of nixpkgs
(cd "$nixpkgs" && update-source-version --ignore-same-version --print-changes --version-key=versions.aarch64-darwin pkgsCross.aarch64-darwin.zoom-us "$version_aarch64_darwin")
(cd "$nixpkgs" && update-source-version --ignore-same-version --print-changes --version-key=versions.x86_64-darwin pkgsCross.x86_64-darwin.zoom-us "$version_x86_64_darwin")
(cd "$nixpkgs" && update-source-version --ignore-same-version --print-changes --version-key=versions.x86_64-linux pkgsCross.gnu64.zoom-us "$version_x86_64_linux" --source-key=unpacked.src)

echo >&2 "=== Done!"
