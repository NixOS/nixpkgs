{ mkDerivation, ansi-terminal, ansi-wl-pprint, array, base, bimap
, binary, bytestring, containers, directory, fetchgit, filepath
, lib, mtl, process, relude, tasty, tasty-discover, tasty-hspec
, tasty-hunit, text
}:
mkDerivation {
  pname = "avh4-lib";
  version = "0.0.0.1";
  src = fetchgit {
    url = "https://github.com/avh4/elm-format";
    sha256 = "0bcjkcs1dy1csz0mpk7d4b5wf93fsj9p86x8fp42mb0pipdd0bh6";
    rev = "80f15d85ee71e1663c9b53903f2b5b2aa444a3be";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/avh4-lib; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    ansi-terminal ansi-wl-pprint array base bimap binary bytestring
    containers directory filepath mtl process relude text
  ];
  testHaskellDepends = [
    ansi-terminal ansi-wl-pprint array base bimap binary bytestring
    containers directory filepath mtl process relude tasty tasty-hspec
    tasty-hunit text
  ];
  testToolDepends = [ tasty-discover ];
  doHaddock = false;
  description = "Common code for haskell projects";
  license = lib.licenses.bsd3;
}
