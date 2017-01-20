#!/bin/sh -e

rm -f node-env.nix
node2nix -i node-packages.json -o node-packages-v4.nix -c composition-v4.nix
node2nix -6 -i node-packages.json -o node-packages-v6.nix -c composition-v6.nix
