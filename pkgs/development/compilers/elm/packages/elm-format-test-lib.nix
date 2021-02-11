{ mkDerivation, avh4-lib, base, containers, fetchgit, filepath
, hspec-core, hspec-golden, lib, mtl, split, tasty, tasty-discover
, tasty-hspec, tasty-hunit, text
}:
mkDerivation {
  pname = "elm-format-test-lib";
  version = "0.0.0.1";
  src = fetchgit {
    url = "https://github.com/avh4/elm-format";
    sha256 = "0bcjkcs1dy1csz0mpk7d4b5wf93fsj9p86x8fp42mb0pipdd0bh6";
    rev = "80f15d85ee71e1663c9b53903f2b5b2aa444a3be";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/elm-format-test-lib; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    avh4-lib base containers filepath hspec-core hspec-golden mtl split
    tasty tasty-hspec tasty-hunit text
  ];
  testHaskellDepends = [
    avh4-lib base containers filepath hspec-core hspec-golden mtl split
    tasty tasty-hspec tasty-hunit text
  ];
  testToolDepends = [ tasty-discover ];
  doHaddock = false;
  description = "Test helpers used by elm-format-tests and elm-refactor-tests";
  license = lib.licenses.bsd3;
}
