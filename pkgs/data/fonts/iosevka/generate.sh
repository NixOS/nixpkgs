#!/bin/sh -e

node2nix -i node-packages.json -c composition.nix -e ../../../development/node-packages/node-env.nix
