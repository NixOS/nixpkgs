{ mkDerivation, avh4-lib, base, containers, fetchgit, filepath
, hspec, hspec-core, hspec-golden, lib, mtl, split, tasty
, tasty-discover, tasty-hspec, tasty-hunit, text
}:
mkDerivation {
  pname = "elm-format-test-lib";
  version = "0.0.0.1";
  src = fetchgit {
    url = "https://github.com/avh4/elm-format";
    sha256 = "1aiq3mv2ycv6bal5hnz6k33bzmnnidzxxs5b6z9y6lvmr0lbf3j4";
    rev = "7e80dd48dd9b30994e43f4804b2ea7118664e8e0";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/elm-format-test-lib; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    avh4-lib base containers filepath hspec hspec-core hspec-golden mtl
    split tasty tasty-hspec tasty-hunit text
  ];
  testHaskellDepends = [
    avh4-lib base containers filepath hspec hspec-core hspec-golden mtl
    split tasty tasty-hspec tasty-hunit text
  ];
  testToolDepends = [ tasty-discover ];
  doHaddock = false;
  description = "Test helpers used by elm-format-tests and elm-refactor-tests";
  license = lib.licenses.bsd3;
}
