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
    rev = "d07fddc8c0eef412dba07be4ab8768d6abcca796";
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
  license = lib.licenses.bsd3;
}
