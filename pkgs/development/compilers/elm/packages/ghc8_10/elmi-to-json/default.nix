{
  mkDerivation,
  aeson,
  base,
  binary,
  bytestring,
  containers,
  directory,
  fetchgit,
  filepath,
  ghc-prim,
  hpack,
  lib,
  optparse-applicative,
  text,
  unliftio,
  unordered-containers,
}:
mkDerivation {
  pname = "elmi-to-json";
  version = "1.3.0";
  src = fetchgit {
    url = "https://github.com/stoeffel/elmi-to-json";
    sha256 = "0vy678k15rzpsn0aly90fb01pxsbqkgf86pa86w0gd94lka8acwl";
    rev = "6a42376ef4b6877e130971faf964578cc096e29b";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson
    base
    binary
    bytestring
    containers
    directory
    filepath
    ghc-prim
    optparse-applicative
    text
    unliftio
    unordered-containers
  ];
  libraryToolDepends = [ hpack ];
  executableHaskellDepends = [ base ];
  testHaskellDepends = [ base ];
  prePatch = "hpack";
  homepage = "https://github.com/stoeffel/elmi-to-json#readme";
  license = lib.licenses.bsd3;
  mainProgram = "elmi-to-json";
}
