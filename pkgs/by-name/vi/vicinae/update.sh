#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils curl common-updater-scripts jq prefetch-npm-deps
# shellcheck shell=bash

set -euo pipefail

version=$(curl -fsSL "https://api.github.com/repos/vicinaehq/vicinae/releases/latest" | jq -er '.tag_name | ltrimstr("v")')

if [[ "$UPDATE_NIX_OLD_VERSION" == "$version" ]]; then
  echo "Already up to date!"
  exit 0
fi

PACKAGE_ROOT=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
NIXPKGS_ROOT=$(realpath "$PACKAGE_ROOT"/../../../..)
tempDir=$(mktemp -d)
trap 'rm -rf "$tempDir"' EXIT

pushd "$tempDir"
curl -fsSL "https://raw.githubusercontent.com/vicinaehq/vicinae/v${version}/src/typescript/api/package-lock.json" -o api-package-lock.json
curl -fsSL "https://raw.githubusercontent.com/vicinaehq/vicinae/v${version}/src/typescript/extension-manager/package-lock.json" -o extension-manager-package-lock.json
curl -fsSL "https://raw.githubusercontent.com/vicinaehq/vicinae/v${version}/cmake/MathText.cmake" -o MathText.cmake
curl -fsSL "https://raw.githubusercontent.com/vicinaehq/vicinae/v${version}/cmake/MediaRemoteAdapter.cmake" -o MediaRemoteAdapter.cmake
newApiDepsHash=$(prefetch-npm-deps api-package-lock.json)
newExtensionManagerDepsHash=$(prefetch-npm-deps extension-manager-package-lock.json)
popd

oldApiDepsHash=$(nix-instantiate --eval --strict --expr \
  "(import \"$NIXPKGS_ROOT\" {}).vicinae.apiDeps.hash" | tr -d '"')
oldExtensionManagerDepsHash=$(nix-instantiate --eval --strict --expr \
  "(import \"$NIXPKGS_ROOT\" {}).vicinae.extensionManagerDeps.hash" | tr -d '"')

cd "$NIXPKGS_ROOT"
update-source-version vicinae "$version" --ignore-same-version --ignore-same-hash
sed -i "s@$oldApiDepsHash@$newApiDepsHash@g" "$PACKAGE_ROOT"/package.nix
sed -i "s@$oldExtensionManagerDepsHash@$newExtensionManagerDepsHash@g" "$PACKAGE_ROOT"/package.nix

mathTextUrl=$(sed -nE 's@^[[:space:]]*URL (https://github.com/jkriege2/JKQtPlotter/archive/[a-f0-9]+\.tar\.gz)[[:space:]]*$@\1@p' "$tempDir/MathText.cmake")
mediaRemoteUrl=$(sed -nE 's@^[[:space:]]*URL (https://github.com/ungive/mediaremote-adapter/archive/[a-f0-9]+\.tar\.gz)[[:space:]]*$@\1@p' "$tempDir/MediaRemoteAdapter.cmake")
: "${mathTextUrl:?Could not find the JKQtPlotter source URL}"
: "${mediaRemoteUrl:?Could not find the mediaremote-adapter source URL}"

mathTextRev=${mathTextUrl##*/}
mathTextRev=${mathTextRev%.tar.gz}
oldMathTextRev=$(nix-instantiate --eval --strict -A vicinae.mathText.src.rev | tr -d '"')
if [[ "$oldMathTextRev" != "$mathTextRev" ]]; then
  mathTextHash=$(nix-prefetch-url --unpack "$mathTextUrl")
  mathTextHash=$(nix --extra-experimental-features nix-command hash to-sri --type sha256 "$mathTextHash")
  update-source-version vicinae "$version" "$mathTextHash" \
    --source-key=mathText.src --rev="$mathTextRev" --ignore-same-version --ignore-same-hash
fi

mediaRemoteRev=${mediaRemoteUrl##*/}
mediaRemoteRev=${mediaRemoteRev%.tar.gz}
oldMediaRemoteRev=$(nix-instantiate --eval --strict -A vicinae.mediaRemoteAdapter.src.rev | tr -d '"')
if [[ "$oldMediaRemoteRev" != "$mediaRemoteRev" ]]; then
  mediaRemoteHash=$(nix-prefetch-url --unpack "$mediaRemoteUrl")
  mediaRemoteHash=$(nix --extra-experimental-features nix-command hash to-sri --type sha256 "$mediaRemoteHash")
  update-source-version vicinae "$version" "$mediaRemoteHash" \
    --source-key=mediaRemoteAdapter.src --rev="$mediaRemoteRev" --ignore-same-version --ignore-same-hash
fi
