#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nix-update elm2nix nixfmt

set -eu -o pipefail

PACKAGE_DIR=$(realpath "$(dirname "$0")")

# Update version, src and npm deps
nix-update "$UPDATE_NIX_ATTR_PATH" --version=unstable

# Update elm deps
cp "$(nix-build -A "$UPDATE_NIX_ATTR_PATH".src)/generator/elm.json" elm.json
trap 'rm -rf elm.json registry.dat &> /dev/null' EXIT
elm2nix convert >"$PACKAGE_DIR/elm-srcs.nix"
nixfmt "$PACKAGE_DIR/elm-srcs.nix"
elm2nix snapshot
cp registry.dat "$PACKAGE_DIR/registry.dat"
