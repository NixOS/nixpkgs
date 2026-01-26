#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./ -i bash -p nix wget prefetch-yarn-deps nix-prefetch-github jq

# shellcheck shell=bash

if [ -n "$GITHUB_TOKEN" ]; then
    TOKEN_ARGS=(--header "Authorization: token $GITHUB_TOKEN")
fi

if [ "$#" -gt 1 ] || [[ "$1" == -* ]]; then
    echo "Regenerates packaging data for the tandoor-recipes package."
    echo "Usage: $0 [git release tag]"
    exit 1
fi

version="$1"

set -euo pipefail

if [ -z "$version" ]; then
    version="$(wget -O- "${TOKEN_ARGS[@]}" "https://api.github.com/repos/TandoorRecipes/recipes/releases?per_page=1" | jq -r '.[0].tag_name')"
fi

package_src="https://raw.githubusercontent.com/TandoorRecipes/recipes/$version"

src_hash=$(nix-prefetch-github TandoorRecipes recipes --rev "${version}" | jq -r .hash)

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

pushd "$tmpdir"
wget "${TOKEN_ARGS[@]}" "$package_src/vue3/yarn.lock"
yarn_hash=$(prefetch-yarn-deps yarn.lock)
popd

# Use friendlier hashes
yarn_hash=$(nix --extra-experimental-features nix-command hash to-sri --type sha256 "$yarn_hash")

common="./pkgs/applications/misc/tandoor-recipes/common.nix"
sed -i -E -e "s#version = \".*\"#version = \"$version\"#" $common
sed -i -E -e "s#hash = \".*\"#hash = \"$src_hash\"#" $common
sed -i -E -e "s#yarnHash = \".*\"#yarnHash = \"$yarn_hash\"#" $common
