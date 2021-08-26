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
readonly SOURCES=(
  "clang-unwrapped.src"
  "compiler-rt.src"
  "clang-unwrapped.clang-tools-extra_src"
  "libcxx.src"
  "libcxxabi.src"
  "libunwind.src"
  "lld.src"
  "lldb.src"
  "llvm.src"
  "llvm.polly_src"
  "openmp.src"
)

for SOURCE in "${SOURCES[@]}"; do
  echo "Updating the hash of $SOURCE:"
  declare ATTR="$ATTRSET.$SOURCE"
  declare OLD_HASH="$(nix eval -f . $ATTR.outputHash)"
  declare NEW_HASH="\"$(nix-prefetch-url -A $ATTR)\""
  find "$DIR" -type f -exec sed -i "s/$OLD_HASH/$NEW_HASH/" {} +
done

echo OK
