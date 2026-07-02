#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils curl jq git gnupg common-updater-scripts
set -euo pipefail

# Fetch latest release, update derivation
scriptDir=$(cd "${BASH_SOURCE[0]%/*}" && pwd)
nixpkgs=$(realpath "$scriptDir"/../../../..)

oldVersion=$(nix-instantiate --eval -E "(import \"$nixpkgs\" { config = {}; overlays = []; }).teos.version" | tr -d '"')
version=$(curl -s --show-error "https://api.github.com/repos/talaia-labs/rust-teos/releases/latest" | jq -r '.tag_name' | tail -c +2)

if [[ $version == $oldVersion ]]; then
  echo "Already at latest version $version"
  exit 0
fi
echo "New version: $version"

tmpdir=$(mktemp -d /tmp/teos.XXX)
repo="${tmpdir}/repo"
trap 'rm -rf $tmpdir' EXIT

git clone --depth 1 --branch "v${version}" -c advice.detachedHead=false 'https://github.com/talaia-labs/rust-teos' "$repo"
git -C "$repo" checkout "tags/v${version}"

rm -rf "${repo}/.git"
hashcheck=$(nix --extra-experimental-features nix-command hash path "$repo")

(cd "$nixpkgs" && update-source-version teos "$version" "$hashcheck" && update-source-version teos --ignore-same-version --source-key=cargoDeps)
echo
echo "rust-teos: $oldVersion -> $version"
