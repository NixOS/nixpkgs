{ mkDerivation, fetchgit, ansi-terminal, ansi-wl-pprint, base, binary
, bytestring, Cabal, cmark, containers, directory, filepath, free
, HUnit, indents, json, mtl, optparse-applicative, parsec, process
, QuickCheck, quickcheck-io, split, stdenv, tasty, tasty-golden
, tasty-hunit, tasty-quickcheck, text
}:
mkDerivation {
  pname = "elm-format";
  version = "0.8.1";
  src = fetchgit {
    url = "https://github.com/avh4/elm-format";
    sha256 = "0p1dy1m6illsl7i04zsv5jqw7i4znv7pfpdfm53zy0k7mq0fk09j";
    rev = "89694e858664329e3cbdaeb71b15c4456fd739ff";
  };
  postPatch = ''
    sed -i "s|desc <-.*||" ./Setup.hs
    sed -i "s|gitDescribe = .*|gitDescribe = \\\\\"0.8.1\\\\\"\"|" ./Setup.hs
  '';
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
  homepage = "https://elm-lang.org";
  description = "A source code formatter for Elm";
  license = stdenv.lib.licenses.bsd3;
}
