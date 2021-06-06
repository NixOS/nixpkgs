#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=../../../../.. -i bash -p nodePackages.node2nix

set -euo pipefail

if [ "$#" -ne 1 ] || [[ "$1" == -* ]]; then
  echo "Regenerates the node composition and package nix files for the material-shell package."
  echo "Usage: $0 <git release tag>"
  exit 1
fi

wget https://github.com/material-shell/material-shell/raw/$1/package.json
wget https://github.com/material-shell/material-shell/raw/$1/package-lock.json

# We need to use --development flag as all the dependencies that are needed are for
# compiling
node2nix \
  --node-env ../../../../development/node-packages/node-env.nix \
  --development \
  --input ./package.json \
  --lock ./package-lock.json \
  --output node-packages.nix \
  --composition node-composition.nix \

rm package.json package-lock.json
