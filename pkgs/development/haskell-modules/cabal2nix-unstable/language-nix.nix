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
  version = "2.3.0-unstable-2026-06-23";
  src = fetchzip {
    url = "https://github.com/NixOS/cabal2nix/archive/bb97bf4294097812718ab9a3f244c9d58c833ae1.tar.gz";
    sha256 = "0bp5m83hzcsr3ga9zz5kq1jjs0n44mlh93x5j55avgw1rxvpfw32";
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
