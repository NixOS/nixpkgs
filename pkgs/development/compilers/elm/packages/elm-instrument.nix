{ mkDerivation, ansi-terminal, ansi-wl-pprint, base, binary
, bytestring, Cabal, cmark, containers, directory, elm-format
, fetchgit, filepath, free, HUnit, indents, json, mtl
, optparse-applicative, parsec, process, QuickCheck, quickcheck-io
, split, stdenv, tasty, tasty-golden, tasty-hunit, tasty-quickcheck
, text, elm
}:
mkDerivation {
  pname = "elm-instrument";
  version = "0.0.7";
  src = fetchgit {
    url = "https://github.com/zwilias/elm-instrument.git";
    sha256 = "14yfzwsyvgc6rzn19sdmwk2mc1vma9hcljnmjnmlig8mp0271v56";
    rev = "31b527e405a6afdb25bb87ad7bd14f979e65cff7";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  setupHaskellDepends = [ base Cabal directory filepath process ];
  libraryHaskellDepends = [
    ansi-terminal ansi-wl-pprint base binary bytestring containers
    directory filepath free indents json mtl optparse-applicative
    parsec process split text
  ];
  executableHaskellDepends = [ base ];
  testHaskellDepends = [
    base cmark containers elm-format HUnit mtl parsec QuickCheck
    quickcheck-io split tasty tasty-golden tasty-hunit tasty-quickcheck
    text
  ];
  homepage = "http://elm-lang.org";
  description = "Instrumentation library for Elm";
  license = stdenv.lib.licenses.bsd3;
}
