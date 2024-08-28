{ mkDerivation, avh4-lib, base, containers, fetchgit, filepath
, hspec, hspec-core, hspec-golden, lib, mtl, split, tasty
, tasty-discover, tasty-hspec, tasty-hunit, text
}:
mkDerivation {
  pname = "elm-format-test-lib";
  version = "0.0.0.1";
  src = fetchgit {
    url = "https://github.com/avh4/elm-format";
    sha256 = "04l1bn4w8q3ifd6mc4mfrqxfbihmqnpfjdn6gr0x2jqcasjbk0bi";
    rev = "b5cca4c26b473dab06e5d73b98148637e4770d45";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/elm-format-test-lib; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    avh4-lib base containers filepath hspec hspec-core hspec-golden mtl
    split tasty-hunit text
  ];
  testHaskellDepends = [
    avh4-lib base containers filepath hspec hspec-core hspec-golden mtl
    split tasty tasty-hspec tasty-hunit text
  ];
  testToolDepends = [ tasty-discover ];
  description = "Test helpers used by elm-format-tests and elm-refactor-tests";
  license = lib.licenses.bsd3;
}
