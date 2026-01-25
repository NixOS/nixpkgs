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
  version = "2.1.3-unstable-2026-01-25";
  src = fetchzip {
    url = "https://github.com/NixOS/cabal2nix/archive/751a8eccfc92f8ce3ca9d517c554e7dcb3f409bd.tar.gz";
    sha256 = "1i9ifxmh5bqgpa7a6l46lqkzpr7z3zfm7bdkllq56hz1nmj4gbqx";
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
