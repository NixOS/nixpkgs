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
  utf8-string,
}:
mkDerivation {
  pname = "hackage-db";
  version = "2.1.3-unstable-2025-09-17";
  src = fetchzip {
    url = "https://github.com/NixOS/cabal2nix/archive/3cc36a5df16a10bac9a858208845e3d05b79845d.tar.gz";
    sha256 = "1z1knv2ggm9ddyl0v120nhcnjmq50z7q1m88qj7rfz51gx1ifnim";
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
    utf8-string
  ];
  homepage = "https://github.com/NixOS/cabal2nix/tree/master/hackage-db#readme";
  description = "Access cabal-install's Hackage database via Data.Map";
  license = lib.licenses.bsd3;
}
