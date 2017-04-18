#!/bin/sh -e

rm -f node-env.nix
node2nix -6 -i node-packages.json -o node-packages-v6.nix -c composition-v6.nix
