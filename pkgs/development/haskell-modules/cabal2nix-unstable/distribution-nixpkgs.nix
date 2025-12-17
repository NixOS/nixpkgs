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
  version = "1.7.1.1-unstable-2025-11-11";
  src = fetchzip {
    url = "https://github.com/NixOS/cabal2nix/archive/a152152295a9fa6698583e84a2b8c7eee1446296.tar.gz";
    sha256 = "1jpgzyc360g5snvc5ji6wqfvbsc7siwxvhrwafzzfg762niq0c49";
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
