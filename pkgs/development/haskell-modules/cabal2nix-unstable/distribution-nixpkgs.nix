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
  version = "1.7.1.1-unstable-2025-10-19";
  src = fetchzip {
    url = "https://github.com/NixOS/cabal2nix/archive/26e5dba9259791d1e80ce68a07f6d20adb26c7eb.tar.gz";
    sha256 = "19y5smq0aji45zak6sxlimzw7ww33zbcmbbrvi2rq40i26mw6kxj";
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
