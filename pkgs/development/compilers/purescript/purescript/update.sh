#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused jq -I nixpkgs=.
#
# This script will update the purescript derivation to the latest version.

set -eo pipefail

# This is the directory of this update.sh script.
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

purescript_derivation_file="${script_dir}/default.nix"

# This is the current revision of PureScript in Nixpkgs.
old_version="$(sed -En 's/.*\bversion = "(.*?)".*/\1/p' "$purescript_derivation_file")"

# This is the latest release version of PureScript on GitHub.
new_version=$(curl --silent "https://api.github.com/repos/purescript/purescript/releases/latest" | jq '.tag_name' --raw-output | sed -e 's/v//')

echo "Updating purescript from old version v${old_version} to new version v${new_version}."
echo

echo "Fetching both old and new release tarballs for Darwin and Linux in order to confirm hashes."
echo
old_linux_version_hash="$(nix-prefetch-url "https://github.com/purescript/purescript/releases/download/v${old_version}/linux64.tar.gz")"
echo "v${old_version} linux tarball hash (current version): $old_linux_version_hash"
new_linux_version_hash="$(nix-prefetch-url "https://github.com/purescript/purescript/releases/download/v${new_version}/linux64.tar.gz")"
echo "v${new_version} linux tarball hash: $new_linux_version_hash"
old_linux_arm_version_hash="$(nix-prefetch-url "https://github.com/purescript/purescript/releases/download/v${old_version}/linux-arm64.tar.gz")"
echo "v${old_version} linux tarball hash (current version): $old_linux_arm_version_hash"
new_linux_arm_version_hash="$(nix-prefetch-url "https://github.com/purescript/purescript/releases/download/v${new_version}/linux-arm64.tar.gz")"
echo "v${new_version} linux tarball hash: $new_linux_arm_version_hash"
old_darwin_version_hash="$(nix-prefetch-url "https://github.com/purescript/purescript/releases/download/v${old_version}/macos.tar.gz")"
echo "v${old_version} darwin tarball hash (current version): $old_darwin_version_hash"
new_darwin_version_hash="$(nix-prefetch-url "https://github.com/purescript/purescript/releases/download/v${new_version}/macos.tar.gz")"
echo "v${new_version} darwin tarball hash: $new_darwin_version_hash"
old_darwin_arm_version_hash="$(nix-prefetch-url "https://github.com/purescript/purescript/releases/download/v${old_version}/macos-arm64.tar.gz")"
echo "v${old_version} darwin arm tarball hash (current version): $old_darwin_arm_version_hash"
new_darwin_arm_version_hash="$(nix-prefetch-url "https://github.com/purescript/purescript/releases/download/v${new_version}/macos-arm64.tar.gz")"
echo "v${new_version} darwin arm tarball hash: $new_darwin_arm_version_hash"
echo

echo "Replacing version and hashes in ${purescript_derivation_file}."
sed -i -e "s/${old_linux_version_hash}/${new_linux_version_hash}/" "$purescript_derivation_file"
sed -i -e "s/${old_linux_arm_version_hash}/${new_linux_arm_version_hash}/" "$purescript_derivation_file"
sed -i -e "s/${old_darwin_version_hash}/${new_darwin_version_hash}/" "$purescript_derivation_file"
sed -i -e "s/${old_darwin_arm_version_hash}/${new_darwin_arm_version_hash}/" "$purescript_derivation_file"
sed -i -e "s/${old_version}/${new_version}/" "$purescript_derivation_file"
echo

echo "Finished.  Make sure you run the following commands to confirm PureScript builds correctly:"
echo ' - `nix build -L -f ./. purescript`'
echo ' - `nix build -L -f ./. purescript.passthru.tests.minimal-module`'
echo ' - `sudo nix build -L -f ./. spago-legacy.passthru.tests --option sandbox relaxed`'
