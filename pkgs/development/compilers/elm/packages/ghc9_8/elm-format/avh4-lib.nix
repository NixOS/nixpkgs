{
  mkDerivation,
  array,
  base,
  bytestring,
  directory,
  fetchgit,
  filepath,
  lib,
  mtl,
  pooled-io,
  process,
  relude,
  tasty,
  tasty-discover,
  tasty-hunit,
  text,
}:
mkDerivation {
  pname = "avh4-lib";
  version = "0.0.0.1";
  src = fetchgit {
    url = "https://github.com/avh4/elm-format";
    sha256 = "13i1wgva6p9zsx1a7sfb3skc0rv187isb920chkhljyh48c12k8l";
    rev = "4c5bfea5f47b38c1fd7ffa431c51c328a3ae5ba6";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/avh4-lib; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    array
    base
    bytestring
    directory
    filepath
    mtl
    pooled-io
    process
    relude
    text
  ];
  testHaskellDepends = [
    array
    base
    bytestring
    directory
    filepath
    mtl
    pooled-io
    process
    relude
    tasty
    tasty-hunit
    text
  ];
  testToolDepends = [ tasty-discover ];
  doHaddock = false;
  description = "Common code for haskell projects";
  license = lib.meta.getLicenseFromSpdxId "BSD-3-Clause";
}
