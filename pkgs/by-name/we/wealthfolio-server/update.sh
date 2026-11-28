#!/usr/bin/env nix-shell
#!nix-shell -i bash
#!nix-shell -p nix-update

nix-update wealthfolio-server --subpackage frontend
