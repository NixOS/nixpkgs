#!/usr/bin/env bash
set -eu -o pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
node2nix=$(nix-build ../../.. --no-out-link -A nodePackages.node2nix)

cd ${DIR}
rm -f ./node-env.nix
${node2nix}/bin/node2nix -i node-packages.json -o node-packages.nix -c composition.nix
