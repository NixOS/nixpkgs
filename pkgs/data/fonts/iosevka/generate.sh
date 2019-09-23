#!/bin/sh

node2nix --nodejs-10 --input node-packages.json \
              --output node-packages-generated.nix \
              --composition node-packages.nix \
              --node-env ./../../../development/node-packages/node-env.nix
