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
  version = "2.1.3-unstable-2026-03-07";
  src = fetchzip {
    url = "https://github.com/NixOS/cabal2nix/archive/977a1c199f7f8092ce9eef7d322b0eecebde22a2.tar.gz";
    sha256 = "0nl5502mpwhmav7qxx051zzyx8ag9mibwhh33bf4aj07ywziza4c";
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
  license = lib.licenses.bsd3;
}
