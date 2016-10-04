#!/bin/sh -e

rm -f node-env.nix
node2nix -i node-packages.json -o node-packages-v4.nix -c composition-v4.nix
node2nix -5 -i node-packages.json -o node-packages-v5.nix -c composition-v5.nix
