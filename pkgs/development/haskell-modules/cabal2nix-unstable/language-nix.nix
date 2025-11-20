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
  version = "2.3.0-unstable-2025-11-20";
  src = fetchzip {
    url = "https://github.com/NixOS/cabal2nix/archive/be62a6c198c6fd082cd5660170fa23a709d92c8e.tar.gz";
    sha256 = "15bfhl0ypnnpgglxc7smppqi3w8w04zi97gh65kk1p6drlg29f47";
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
  license = lib.licenses.bsd3;
}
