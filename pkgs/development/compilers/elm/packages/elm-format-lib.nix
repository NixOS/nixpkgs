{ mkDerivation, aeson, ansi-terminal, ansi-wl-pprint, array
, avh4-lib, base, bimap, binary, bytestring, containers, directory
, elm-format-markdown, elm-format-test-lib, fetchgit, filepath
, ghc-prim, hspec, lib, mtl, optparse-applicative, process, relude
, split, tasty, tasty-discover, tasty-hspec, tasty-hunit, text
}:
mkDerivation {
  pname = "elm-format-lib";
  version = "0.0.0.1";
  src = fetchgit {
    url = "https://github.com/avh4/elm-format";
    sha256 = "1aiq3mv2ycv6bal5hnz6k33bzmnnidzxxs5b6z9y6lvmr0lbf3j4";
    rev = "7e80dd48dd9b30994e43f4804b2ea7118664e8e0";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/elm-format-lib; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson ansi-terminal ansi-wl-pprint array avh4-lib base bimap binary
    bytestring containers directory elm-format-markdown filepath
    ghc-prim mtl optparse-applicative process relude text
  ];
  testHaskellDepends = [
    aeson ansi-terminal ansi-wl-pprint array avh4-lib base bimap binary
    bytestring containers directory elm-format-markdown
    elm-format-test-lib filepath ghc-prim hspec mtl
    optparse-applicative process relude split tasty tasty-hspec
    tasty-hunit text
  ];
  testToolDepends = [ tasty-discover ];
  doHaddock = false;
  description = "Common code used by elm-format and elm-refactor";
  license = lib.licenses.bsd3;
}
