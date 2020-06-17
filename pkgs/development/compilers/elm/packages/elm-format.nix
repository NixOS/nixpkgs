{ mkDerivation, fetchgit, ansi-terminal, ansi-wl-pprint, base, binary
, bytestring, cmark, containers, directory, filepath, free, HUnit
, indents, json, mtl, optparse-applicative, parsec, process
, QuickCheck, quickcheck-io, split, stdenv, tasty, tasty-golden
, tasty-hunit, tasty-quickcheck, text
}:
mkDerivation {
  pname = "elm-format";
  version = "0.8.3";
  src = fetchgit {
    url = "https://github.com/avh4/elm-format";
    sha256 = "0n6lrqj6mq044hdyraj3ss5cg74dn8k4z05xmwn2apjpm146iaw8";
    rev = "b97e3593d564a1e069c0a022da8cbd98ca2c5a4b";
  };
  postPatch = ''
    mkdir -p ./generated
    cat <<EOHS > ./generated/Build_elm_format.hs
    module Build_elm_format where

    gitDescribe :: String
    gitDescribe = "0.8.3"
    EOHS
  '';
  isLibrary = false;
  isExecutable = true;
  libraryHaskellDepends = [
    ansi-terminal ansi-wl-pprint base binary bytestring containers
    directory filepath free indents json mtl optparse-applicative
    parsec process split text
  ];
  executableHaskellDepends = [ base ];
  testHaskellDepends = [
    base cmark containers HUnit mtl parsec QuickCheck quickcheck-io
    split tasty tasty-golden tasty-hunit tasty-quickcheck text
  ];
  doHaddock = false;
  homepage = "https://elm-lang.org";
  description = "A source code formatter for Elm";
  license = stdenv.lib.licenses.bsd3;
}
