#!/usr/bin/env bash
set -eu -o pipefail

node2nix=$(nix-build ../../../.. --no-out-link -A nodePackages.node2nix)

exec ${node2nix}/bin/node2nix --nodejs-10 \
    -i node-packages.json -o node-packages.nix \
    -c google-clasp.nix \
     --no-copy-node-env -e ../../../development/node-packages/node-env.nix
