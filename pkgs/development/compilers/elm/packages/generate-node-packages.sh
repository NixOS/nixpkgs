#!/usr/bin/env bash

ROOT="$(realpath "$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")"/../../../../..)"

set -eu -o pipefail

rm -f node-env.nix
$(nix-build $ROOT -A nodePackages.node2nix --no-out-link)/bin/node2nix \
    --nodejs-10 \
    -i node-packages.json \
    -o node-packages.nix \
    -c node-composition.nix \
    --no-copy-node-env -e ../../../node-packages/node-env.nix
