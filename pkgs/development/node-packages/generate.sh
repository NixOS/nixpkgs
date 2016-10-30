#!/bin/sh -e

rm -f node-env.nix
node2nix -5 -i node-packages.json -o node-packages-v5.nix -c composition-v5.nix
