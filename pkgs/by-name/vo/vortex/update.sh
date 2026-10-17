#!/usr/bin/env nix-shell
#!nix-shell --pure -i bash -p nix-update

set -eu -o pipefail

scriptDir=$(cd "${BASH_SOURCE[0]%/*}" && pwd)
nixpkgs=$(realpath "$scriptDir"/../../../..)
cd "$nixpkgs"

# Normalize update variables, usually provided by the update shell
export UPDATE_NIX_ATTR_PATH="${UPDATE_NIX_ATTR_PATH:-vortex}"
if [ -z "${UPDATE_NIX_OLD_VERSION:-}" ]; then
  UPDATE_NIX_OLD_VERSION=$(nix-instantiate --raw --eval -A "$UPDATE_NIX_ATTR_PATH.version")
fi
if [ -z "${UPDATE_NIX_PNAME:-}" ]; then
  UPDATE_NIX_PNAME=$(nix-instantiate --raw --eval -A "$UPDATE_NIX_ATTR_PATH.pname")
fi
if [ -z "${UPDATE_NIX_NAME:-}" ]; then
  UPDATE_NIX_NAME=$(nix-instantiate --raw --eval -A "$UPDATE_NIX_ATTR_PATH.name")
fi
export UPDATE_NIX_ATTR_PATH UPDATE_NIX_OLD_VERSION UPDATE_NIX_PNAME UPDATE_NIX_NAME

# Do the actual update
nix-update
"$scriptDir/pnpm-github-lock.py"
