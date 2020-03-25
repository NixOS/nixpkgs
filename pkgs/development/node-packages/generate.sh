#!/usr/bin/env nix-shell
#! nix-shell -p nodePackages.node2nix -i bash
set -eu -o pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd ${DIR}
rm -f ./node-env.nix
for version in 10 12 13; do
  node2nix --nodejs-$version -i node-packages-v$version.json -o node-packages-v$version.nix -c composition-v$version.nix
done
