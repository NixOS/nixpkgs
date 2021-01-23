{ mkDerivation, fetchgit, ansi-terminal, ansi-wl-pprint, array, base, binary
, bytestring, cmark, containers, directory, filepath, free, HUnit
, indents, json, mtl, optparse-applicative, parsec, process
, QuickCheck, quickcheck-io, split, lib, stdenv, tasty, tasty-golden
, tasty-hunit, tasty-quickcheck, text
}:
mkDerivation {
  pname = "elm-format";
  version = "0.8.4";
  src = fetchgit {
    url = "https://github.com/avh4/elm-format";
    sha256 = "0cxlhhdjx4h9g03z83pxv91qrysbi0ab92rl52jb0yvkaix989ai";
    rev = "5bd4fbe591fe8b456160c180cb875ef60bc57890";
  };
  postPatch = ''
    mkdir -p ./generated
    cat <<EOHS > ./generated/Build_elm_format.hs
    module Build_elm_format where

    gitDescribe :: String
    gitDescribe = "0.8.4"
    EOHS
  '';
  isLibrary = false;
  isExecutable = true;
  libraryHaskellDepends = [
    ansi-terminal ansi-wl-pprint array base binary bytestring
    containers directory filepath free indents json mtl
    optparse-applicative parsec process split text
  ];
  executableHaskellDepends = [ base ];
  testHaskellDepends = [
    base cmark containers HUnit mtl parsec QuickCheck quickcheck-io
    split tasty tasty-golden tasty-hunit tasty-quickcheck text
  ];
  doHaddock = false;
  homepage = "https://elm-lang.org";
  description = "A source code formatter for Elm";
  license = lib.licenses.bsd3;
}
