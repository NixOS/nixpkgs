{ mkDerivation, ansi-terminal, ansi-wl-pprint, array, base, bimap
, binary, bytestring, containers, directory, fetchgit, filepath
, lib, mtl, pooled-io, process, relude, tasty, tasty-discover
, tasty-hspec, tasty-hunit, text
}:
mkDerivation {
  pname = "avh4-lib";
  version = "0.0.0.1";
  src = fetchgit {
    url = "https://github.com/avh4/elm-format";
    sha256 = "1aiq3mv2ycv6bal5hnz6k33bzmnnidzxxs5b6z9y6lvmr0lbf3j4";
    rev = "7e80dd48dd9b30994e43f4804b2ea7118664e8e0";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/avh4-lib; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    ansi-terminal ansi-wl-pprint array base bimap binary bytestring
    containers directory filepath mtl pooled-io process relude text
  ];
  testHaskellDepends = [
    ansi-terminal ansi-wl-pprint array base bimap binary bytestring
    containers directory filepath mtl pooled-io process relude tasty
    tasty-hspec tasty-hunit text
  ];
  testToolDepends = [ tasty-discover ];
  doHaddock = false;
  description = "Common code for haskell projects";
  license = lib.licenses.bsd3;
}
