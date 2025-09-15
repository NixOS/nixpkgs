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
  version = "2.1.3-unstable-2025-09-15";
  src = fetchzip {
    url = "https://github.com/NixOS/cabal2nix/archive/959e18599e18092359627613f5b66b08520b9651.tar.gz";
    sha256 = "1w6pvy3x8sd14053yzad70h9k9q8dsgv0wqiw9xmfwq11f0195nr";
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
