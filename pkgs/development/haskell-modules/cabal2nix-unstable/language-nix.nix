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
  version = "2.2.0-unstable-2025-08-10";
  src = fetchzip {
    url = "https://github.com/NixOS/cabal2nix/archive/31c6db234a905bbf4e8f34c5a986f294b231de0a.tar.gz";
    sha256 = "1ifbmcm5k8mxcpq4kscfc5ddcknawxz6a4ak30jmf0kk1lrfsikf";
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
