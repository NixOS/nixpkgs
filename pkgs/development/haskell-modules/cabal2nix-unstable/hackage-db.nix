# This file defines hackage-db-unstable, used by maintainers/scripts/haskell/regenerate-hackage-packages.sh.
{
  mkDerivation,
  aeson,
  base,
  bytestring,
  Cabal,
  containers,
  directory,
  exceptions,
  fetchzip,
  filepath,
  lib,
  tar,
  time,
}:
mkDerivation {
  pname = "hackage-db";
  version = "2.1.3-unstable-2026-08-21";
  src = fetchzip {
    url = "https://github.com/NixOS/cabal2nix/archive/b9ef7e13a1eebdf9cb56518b5010befa1ca505af.tar.gz";
    sha256 = "052kdc9rli92pyk45p3ly2xgvhm312ik7d22khxw9rsphpsr4n8d";
  };
  postUnpack = "sourceRoot+=/hackage-db; echo source root reset to $sourceRoot";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson
    base
    bytestring
    Cabal
    containers
    directory
    exceptions
    filepath
    tar
    time
  ];
  homepage = "https://github.com/NixOS/cabal2nix/tree/master/hackage-db#readme";
  description = "Access cabal-install's Hackage database via Data.Map";
  license = lib.meta.getLicenseFromSpdxId "BSD-3-Clause";
}
