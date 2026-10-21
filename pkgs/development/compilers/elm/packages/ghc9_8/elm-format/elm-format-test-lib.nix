{
  mkDerivation,
  avh4-lib,
  base,
  containers,
  fetchgit,
  filepath,
  hspec,
  hspec-core,
  hspec-golden,
  lib,
  mtl,
  split,
  tasty,
  tasty-discover,
  tasty-hspec,
  tasty-hunit,
  text,
}:
mkDerivation {
  pname = "elm-format-test-lib";
  version = "0.0.0.1";
  src = fetchgit {
    url = "https://github.com/avh4/elm-format";
    sha256 = "13i1wgva6p9zsx1a7sfb3skc0rv187isb920chkhljyh48c12k8l";
    rev = "4c5bfea5f47b38c1fd7ffa431c51c328a3ae5ba6";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/elm-format-test-lib; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    avh4-lib
    base
    containers
    filepath
    hspec
    hspec-core
    hspec-golden
    mtl
    split
    tasty-hunit
    text
  ];
  testHaskellDepends = [
    avh4-lib
    base
    containers
    filepath
    hspec
    hspec-core
    hspec-golden
    mtl
    split
    tasty
    tasty-hspec
    tasty-hunit
    text
  ];
  testToolDepends = [ tasty-discover ];
  doHaddock = false;
  description = "Test helpers used by elm-format-tests and elm-refactor-tests";
  license = lib.meta.getLicenseFromSpdxId "BSD-3-Clause";
}
