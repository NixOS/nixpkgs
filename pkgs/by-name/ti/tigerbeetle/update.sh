#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix mktemp unzip gnused

set -euo pipefail

latest_release_info=$(curl -s ${GITHUB_TOKEN:+ -H "Authorization: Bearer $GITHUB_TOKEN"} https://api.github.com/repos/tigerbeetle/tigerbeetle/releases?per_page=5 | jq -r "map(select(.properties.draft and .properties.prerelease | not)) | .[0]")
latestVersion=$(jq -r ".tag_name" <<< $latest_release_info)
currentVersion=$(nix-instantiate --eval -E "let pkgs = import ./. {}; in pkgs.tigerbeetle.version" | tr -d '"')

if [[ "$currentVersion" == "$latestVersion" ]]
then
    echo "New version same as old version, nothing to do." >&2
    exit 0
fi

# Note: our own nix-prefetch-url impersonation because the way that nix-prefetch-url treats tigerbeetle's zip files (which are just a single executable, no directories) is different from how Nixpkgs's fetchzip treats them.
retrieved_hash=""
function retrieve_hash {
    download_dir=$(mktemp -d)
    curl -s --location $1 --output "$download_dir/tigerbeetle.zip"
    unzip -q "$download_dir/tigerbeetle.zip" -d "$download_dir"
    rm "$download_dir/tigerbeetle.zip"
    retrieved_hash=$(nix --extra-experimental-features nix-command hash path "$download_dir")
    rm -rf "$download_dir"
}

nixFile=$(nix-instantiate --eval --strict -A "tigerbeetle.meta.position" | sed -re 's/^"(.*):[0-9]+"$/\1/')

sed -i "s|\(version = \"\)\(.*\)\"|\1$latestVersion\"|" $nixFile
retrieve_hash "https://github.com/tigerbeetle/tigerbeetle/releases/download/${latestVersion}/tigerbeetle-x86_64-linux.zip"
sed -i "s|\(\"x86_64-linux\" = \"\)\(.*\)\"|\1$retrieved_hash\"|" $nixFile
retrieve_hash "https://github.com/tigerbeetle/tigerbeetle/releases/download/${latestVersion}/tigerbeetle-aarch64-linux.zip"
sed -i "s|\(\"aarch64-linux\" = \"\)\(.*\)\"|\1$retrieved_hash\"|" $nixFile
retrieve_hash "https://github.com/tigerbeetle/tigerbeetle/releases/download/${latestVersion}/tigerbeetle-universal-macos.zip"
sed -i "s|\(\"universal-macos\" = \"\)\(.*\)\"|\1$retrieved_hash\"|" $nixFile
