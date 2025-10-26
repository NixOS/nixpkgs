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
  QuickCheck,
}:
mkDerivation {
  pname = "language-nix";
  version = "2.3.0-unstable-2025-10-25";
  src = fetchzip {
    url = "https://github.com/NixOS/cabal2nix/archive/19800f3819e099dba344001d0d0f5c15698bc793.tar.gz";
    sha256 = "02zxw06d5c9zh63kra9sx3rfcgb8xqaz77b5za0jxvkjxjl9ysyn";
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
    QuickCheck
  ];
  homepage = "https://github.com/NixOS/cabal2nix/tree/master/language-nix#readme";
  description = "Data types and functions to represent the Nix language";
  license = lib.licenses.bsd3;
}
