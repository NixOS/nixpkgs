#!/usr/bin/env bash

ROOT="$(realpath "$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")"/../../../../../..)"

set -eu -o pipefail

$(nix-build $ROOT -A nodePackages.node2nix --no-out-link)/bin/node2nix \
    --nodejs-18 \
    -i node-packages.json \
    -o node-packages.nix \
    -c node-composition.nix \
    --no-copy-node-env -e ../../../../node-packages/node-env.nix
# well, elm-pages requires two different version of esbuild so we twist it's wrist to only use one
sed -i 's/sources."esbuild-0.19.12"/sources."esbuild-0.21.5"/' node-packages.nix
