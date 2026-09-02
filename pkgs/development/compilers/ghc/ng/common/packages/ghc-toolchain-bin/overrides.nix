# Upstream carries no `license:` field at all, so cabal2nix emits
# `license = "unknown"`. It is BSD-3 like the rest of GHC;
# `pkgs/development/tools/haskell/hadrian/ghc-toolchain.nix` already asserts as
# much.
{ lib, ... }:
_: _: {
  license = lib.licenses.bsd3;
}
