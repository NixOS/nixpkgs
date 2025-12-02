#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils curl common-updater-scripts jq prefetch-npm-deps
# shellcheck shell=bash

set -euo pipefail

version=$(curl -s "https://api.github.com/repos/vicinaehq/vicinae/releases/latest" | jq -r ".tag_name" | tr -d v)

if [[ "$UPDATE_NIX_OLD_VERSION" == "$version" ]]; then
  echo "Already up to date!"
  exit 0
fi

pushd "$(mktemp -d)"
curl -s "https://raw.githubusercontent.com/vicinaehq/vicinae/v${version}/typescript/api/package-lock.json" -o api-package-lock.json
curl -s "https://raw.githubusercontent.com/vicinaehq/vicinae/v${version}/typescript/extension-manager/package-lock.json" -o extension-manager-package-lock.json
newApiDepsHash=$(prefetch-npm-deps api-package-lock.json)
newExtensionManagerDepsHash=$(prefetch-npm-deps extension-manager-package-lock.json)
popd

PACKAGE_ROOT=$(dirname "${BASH_SOURCE[0]}")
NIXPKGS_ROOT=$(realpath "$PACKAGE_ROOT"/../../../..)

oldApiDepsHash=$(nix-instantiate --eval --strict --expr \
  "(import \"$NIXPKGS_ROOT\" {}).vicinae.apiDeps.hash" | tr -d '"')
oldExtensionManagerDepsHash=$(nix-instantiate --eval --strict --expr \
  "(import \"$NIXPKGS_ROOT\" {}).vicinae.extensionManagerDeps.hash" | tr -d '"')

update-source-version vicinae "$version"
sed -i "s@$oldApiDepsHash@$newApiDepsHash@g" "$PACKAGE_ROOT"/package.nix
sed -i "s@$oldExtensionManagerDepsHash@$newExtensionManagerDepsHash@g" "$PACKAGE_ROOT"/package.nix
