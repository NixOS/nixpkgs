#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix

set -eu -o pipefail

rm -f node-env.nix
node2nix --nodejs-10 \
    -i node-packages.json \
    -o node-packages.nix \
    -c node-composition.nix \
    --no-copy-node-env -e ../../../node-packages/node-env.nix
