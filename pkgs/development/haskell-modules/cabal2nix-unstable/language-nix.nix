# This file defines language-nix-unstable, used by maintainers/scripts/haskell/regenerate-hackage-packages.sh.
{
  mkDerivation,
  base,
  deepseq,
  fetchzip,
  hspec,
  lens,
  lib,
  parsec-class,
  pretty,
  process,
  QuickCheck,
}:
mkDerivation {
  pname = "language-nix";
  version = "2.3.0-unstable-2026-08-21";
  src = fetchzip {
    url = "https://github.com/NixOS/cabal2nix/archive/b9ef7e13a1eebdf9cb56518b5010befa1ca505af.tar.gz";
    sha256 = "052kdc9rli92pyk45p3ly2xgvhm312ik7d22khxw9rsphpsr4n8d";
  };
  postUnpack = "sourceRoot+=/language-nix; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    base
    deepseq
    lens
    parsec-class
    pretty
    QuickCheck
  ];
  testHaskellDepends = [
    base
    hspec
    lens
    parsec-class
    pretty
    process
    QuickCheck
  ];
  homepage = "https://github.com/NixOS/cabal2nix/tree/master/language-nix#readme";
  description = "Data types and functions to represent the Nix language";
  license = lib.meta.getLicenseFromSpdxId "BSD-3-Clause";
}
