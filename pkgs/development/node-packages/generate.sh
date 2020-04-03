#!/usr/bin/env bash
set -eu -o pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
node2nix=$(nix-build ../../.. --no-out-link -A nodePackages.node2nix)

cd ${DIR}
rm -f ./node-env.nix
for version in 10 12 13; do
  "${node2nix}/bin/node2nix" --nodejs-$version -i node-packages-v$version.json -o node-packages-v$version.nix -c composition-v$version.nix
done
