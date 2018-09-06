{ mkDerivation, ansi-terminal, ansi-wl-pprint, base, binary
, bytestring, Cabal, cmark, containers, directory, fetchgit
, filepath, free, HUnit, indents, json, mtl, optparse-applicative
, parsec, process, QuickCheck, quickcheck-io, split, stdenv, tasty
, tasty-golden, tasty-hunit, tasty-quickcheck, text
}:
mkDerivation {
  pname = "elm-format";
  version = "0.8.0";
  src = fetchgit {
    url = "http://github.com/avh4/elm-format";
    sha256 = "1w79xvsyq98vfz3jb4sv8433vdh6pcg8s7yh54lcxzr1p08yhsb6";
    rev = "f19ac28046d7e83ff95f845849c033cc616f1bd6";
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
    base cmark containers HUnit mtl parsec QuickCheck quickcheck-io
    split tasty tasty-golden tasty-hunit tasty-quickcheck text
  ];
  doHaddock = false;
  jailbreak = true;
  doCheck = false;
  homepage = "http://elm-lang.org";
  description = "A source code formatter for Elm";
  license = stdenv.lib.licenses.bsd3;
}
