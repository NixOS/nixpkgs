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
  version = "2.3.0-unstable-2026-11-06";
  src = fetchzip {
    url = "https://github.com/NixOS/cabal2nix/archive/422b50d0e6fdd033f20ae1f0e013cb5c0674f731.tar.gz";
    sha256 = "0dfis02hsh44h9k95mfsp4v422zw94w2pfz6dk43yx3dvqisv72c";
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
