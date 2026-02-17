# This file defines distribution-nixpkgs-unstable, used by maintainers/scripts/haskell/regenerate-hackage-packages.sh.
{
  mkDerivation,
  aeson,
  base,
  bytestring,
  Cabal,
  containers,
  deepseq,
  directory,
  fetchzip,
  hspec,
  language-nix,
  lens,
  lib,
  pretty,
  process,
}:
mkDerivation {
  pname = "distribution-nixpkgs";
  version = "1.7.1.1-unstable-2026-01-25";
  src = fetchzip {
    url = "https://github.com/NixOS/cabal2nix/archive/751a8eccfc92f8ce3ca9d517c554e7dcb3f409bd.tar.gz";
    sha256 = "1i9ifxmh5bqgpa7a6l46lqkzpr7z3zfm7bdkllq56hz1nmj4gbqx";
  };
  postUnpack = "sourceRoot+=/distribution-nixpkgs; echo source root reset to $sourceRoot";
  enableSeparateDataOutput = true;
  libraryHaskellDepends = [
    aeson
    base
    bytestring
    Cabal
    containers
    deepseq
    language-nix
    lens
    pretty
    process
  ];
  testHaskellDepends = [
    aeson
    base
    Cabal
    deepseq
    directory
    hspec
    language-nix
    lens
  ];
  homepage = "https://github.com/NixOS/cabal2nix/tree/master/distribution-nixpkgs#readme";
  description = "Types and functions to manipulate the Nixpkgs distribution";
  license = lib.licenses.bsd3;
}
