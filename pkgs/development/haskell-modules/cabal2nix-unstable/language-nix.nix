# This file defines language-nix-unstable, used by maintainers/scripts/haskell/regenerate-hackage-packages.sh.
{
  mkDerivation,
  base,
  deepseq,
  fetchzip,
  lens,
  lib,
  parsec-class,
  pretty,
  QuickCheck,
}:
mkDerivation {
  pname = "language-nix";
  version = "2.2.0-unstable-2025-09-09";
  src = fetchzip {
    url = "https://github.com/NixOS/cabal2nix/archive/987474e0b0ed1c6b0e3fd0d07313f6996ec98b7e.tar.gz";
    sha256 = "0nixn8incqypsfyfclj40p8bdx2yn4783kzwpqfp19ql2sbc57dc";
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
  homepage = "https://github.com/NixOS/cabal2nix/tree/master/language-nix#readme";
  description = "Data types and functions to represent the Nix language";
  license = lib.licenses.bsd3;
}
