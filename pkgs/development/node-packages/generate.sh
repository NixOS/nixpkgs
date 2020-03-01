#!/usr/bin/env nix-shell
#! nix-shell shell-generate.nix -i bash
set -eu -o pipefail

cd "$NODE_NIXPKGS_PATH"
rm -f ./node-env.nix
for version in 10 12 13; do
    node2nix --nodejs-$version -i node-packages-v$version.json -o node-packages-v$version.nix -c composition-v$version.nix
done
cd -
