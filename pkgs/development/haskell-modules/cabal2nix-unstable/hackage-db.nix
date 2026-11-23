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
  version = "2.1.3-unstable-2026-11-06";
  src = fetchzip {
    url = "https://github.com/NixOS/cabal2nix/archive/422b50d0e6fdd033f20ae1f0e013cb5c0674f731.tar.gz";
    sha256 = "0dfis02hsh44h9k95mfsp4v422zw94w2pfz6dk43yx3dvqisv72c";
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
