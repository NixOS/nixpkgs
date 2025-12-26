#!/usr/bin/env bash

set -eu

# Example usage: ./pkgs/development/compilers/llvm/update.sh 12.0.0-rc4

readonly VERSION="$1"
readonly VERSION_MAJOR="${VERSION%%.*}"
readonly VERSION_MAIN="${VERSION%%-*}"
declare VERSION_PATCH="${VERSION/$VERSION_MAIN/}"
readonly VERSION_PATCH="${VERSION_PATCH/-/}"

readonly DIR="pkgs/development/compilers/llvm/$VERSION_MAJOR"
readonly FILE="$DIR/default.nix"

sed -Ei \
  -e "s/release_version = \".+\";/release_version = \"$VERSION_MAIN\";/" \
  -e "s/candidate = \".*\";/candidate = \"$VERSION_PATCH\";/" \
  "$FILE"

readonly ATTRSET="llvmPackages_$VERSION_MAJOR"

echo "Updating the hash of llvm.monorepoSrc:"
declare ATTR="$ATTRSET.llvm.monorepoSrc"
declare OLD_HASH="$(nix --extra-experimental-features nix-command eval -f . $ATTR.outputHash)"
declare NEW_HASH="\"$(nix-prefetch-url -A $ATTR)\""
find "$DIR" -type f -exec sed -i "s/$OLD_HASH/$NEW_HASH/" {} +

echo OK
