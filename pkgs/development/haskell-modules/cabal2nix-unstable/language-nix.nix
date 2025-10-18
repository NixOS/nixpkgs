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
  version = "2.3.0-unstable-2025-10-19";
  src = fetchzip {
    url = "https://github.com/NixOS/cabal2nix/archive/26e5dba9259791d1e80ce68a07f6d20adb26c7eb.tar.gz";
    sha256 = "19y5smq0aji45zak6sxlimzw7ww33zbcmbbrvi2rq40i26mw6kxj";
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
