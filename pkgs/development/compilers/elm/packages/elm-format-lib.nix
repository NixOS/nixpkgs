{ mkDerivation, ansi-terminal, ansi-wl-pprint, array, avh4-lib
, base, bimap, binary, bytestring, containers, directory
, elm-format-markdown, elm-format-test-lib, fetchgit, filepath
, indents, json, lib, mtl, optparse-applicative, parsec, process
, relude, split, tasty, tasty-discover, tasty-hspec, tasty-hunit
, text
}:
mkDerivation {
  pname = "elm-format-lib";
  version = "0.0.0.1";
  src = fetchgit {
    url = "https://github.com/avh4/elm-format";
    sha256 = "0bcjkcs1dy1csz0mpk7d4b5wf93fsj9p86x8fp42mb0pipdd0bh6";
    rev = "80f15d85ee71e1663c9b53903f2b5b2aa444a3be";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/elm-format-lib; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    ansi-terminal ansi-wl-pprint array avh4-lib base bimap binary
    bytestring containers directory elm-format-markdown filepath
    indents json mtl optparse-applicative parsec process relude text
  ];
  testHaskellDepends = [
    ansi-terminal ansi-wl-pprint array avh4-lib base bimap binary
    bytestring containers directory elm-format-markdown
    elm-format-test-lib filepath indents json mtl optparse-applicative
    parsec process relude split tasty tasty-hspec tasty-hunit text
  ];
  testToolDepends = [ tasty-discover ];
  doHaddock = false;
  description = "Common code used by elm-format and elm-refactor";
  license = lib.licenses.bsd3;
}
