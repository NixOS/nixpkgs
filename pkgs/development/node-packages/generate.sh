#!/usr/bin/env nix-shell
#! nix-shell shell-generate.nix -i bash
set -eu -o pipefail

cd "$NODE_NIXPKGS_PATH/pkgs/development/node-packages"
rm -f ./node-env.nix
for version in 10 12 13; do
    tmpdir=$(mktemp -d)
    node2nix --nodejs-$version -i node-packages-v$version.json -o $tmpdir/node-packages-v$version.nix -c $tmpdir/composition-v$version.nix
    if [ $? -eq 0 ]; then
        mv $tmpdir/node-packages-v$version.nix .
        mv $tmpdir/composition-v$version.nix .
    fi
done
cd -
