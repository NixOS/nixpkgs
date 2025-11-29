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
  version = "1.7.1.1-unstable-2025-11-20";
  src = fetchzip {
    url = "https://github.com/NixOS/cabal2nix/archive/459859839cfe4fb352a29c1a72a1c4f0f537a1b8.tar.gz";
    sha256 = "1443hlbz29y2dn22kf91zx7g284zp3l2vgw6jg4wgx66v2sxrqii";
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
