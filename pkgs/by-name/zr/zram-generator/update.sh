#! /usr/bin/env nix-shell
#! nix-shell -i bash -p coreutils curl jq common-updater-scripts cargo
# shellcheck shell=bash

set -euo pipefail

version=$(curl -s https://api.github.com/repos/systemd/zram-generator/tags | jq -r '.[0].name')
update-source-version zram-generator "${version#v}"

tmp=$(mktemp -d)
trap 'rm -rf -- "${tmp}"' EXIT

git clone --depth 1 --branch "${version}" https://github.com/systemd/zram-generator.git "${tmp}/zram-generator"
cargo generate-lockfile --manifest-path "${tmp}/zram-generator/Cargo.toml"
cp "${tmp}/zram-generator/Cargo.lock" "$(dirname "$0")/Cargo.lock"
