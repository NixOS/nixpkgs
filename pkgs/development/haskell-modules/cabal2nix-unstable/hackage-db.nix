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
  version = "2.1.3-unstable-2026-06-23";
  src = fetchzip {
    url = "https://github.com/NixOS/cabal2nix/archive/bb97bf4294097812718ab9a3f244c9d58c833ae1.tar.gz";
    sha256 = "0bp5m83hzcsr3ga9zz5kq1jjs0n44mlh93x5j55avgw1rxvpfw32";
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
