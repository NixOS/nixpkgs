#!/usr/bin/env nix-shell
#!nix-shell -i bash -p cabal2nix

set -x
set -eo pipefail

cabal2nix cabal://bower-json-1.0.0.1 > generated/bower-json.nix
cabal2nix cabal://language-javascript-0.7.0.0 > generated/language-javascript.nix
cabal2nix https://hackage.haskell.org/package/lens-4.19.2/revision/6.cabal > generated/lens.nix
cabal2nix cabal://memory-0.15.0 > generated/memory.nix
cabal2nix cabal://semialign-1.1.0.1 > generated/semialign.nix
cabal2nix cabal://vector-0.12.3.1 > generated/vector.nix
cabal2nix cabal://witherable-0.4.1 > generated/witherable.nix
cabal2nix --revision v0.15.2 https://github.com/purescript/purescript > generated/purescript.nix

