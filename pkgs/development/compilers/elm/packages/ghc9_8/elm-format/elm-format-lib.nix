{
  mkDerivation,
  aeson,
  avh4-lib,
  base,
  bimap,
  binary,
  bytestring,
  containers,
  elm-format-markdown,
  elm-format-test-lib,
  fetchgit,
  hspec,
  lib,
  mtl,
  optparse-applicative,
  relude,
  split,
  tasty,
  tasty-discover,
  tasty-hspec,
  tasty-hunit,
  text,
}:
mkDerivation {
  pname = "elm-format-lib";
  version = "0.0.0.1";
  src = fetchgit {
    url = "https://github.com/avh4/elm-format";
    sha256 = "13i1wgva6p9zsx1a7sfb3skc0rv187isb920chkhljyh48c12k8l";
    rev = "d07fddc8c0eef412dba07be4ab8768d6abcca796";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/elm-format-lib; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson
    avh4-lib
    base
    bimap
    binary
    bytestring
    containers
    elm-format-markdown
    mtl
    optparse-applicative
    relude
    text
  ];
  testHaskellDepends = [
    aeson
    avh4-lib
    base
    bimap
    binary
    bytestring
    containers
    elm-format-markdown
    elm-format-test-lib
    hspec
    mtl
    optparse-applicative
    relude
    split
    tasty
    tasty-hspec
    tasty-hunit
    text
  ];
  testToolDepends = [ tasty-discover ];
  doHaddock = false;
  description = "Common code used by elm-format and elm-refactor";
  license = lib.licenses.bsd3;
}
