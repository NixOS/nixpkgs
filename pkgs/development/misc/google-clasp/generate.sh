#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix
# shellcheck shell=bash

set -eu -o pipefail

exec node2nix --nodejs-10 \
    -i node-packages.json -o node-packages.nix \
    -c google-clasp.nix \
     --no-copy-node-env -e ../../../development/node-packages/node-env.nix
