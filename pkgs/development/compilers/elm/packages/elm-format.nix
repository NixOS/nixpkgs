{ mkDerivation, ansi-terminal, ansi-wl-pprint, base, binary
, bytestring, Cabal, cmark, containers, directory, fetchgit
, filepath, free, HUnit, indents, json, mtl, optparse-applicative
, parsec, process, QuickCheck, quickcheck-io, split, stdenv, tasty
, tasty-golden, tasty-hunit, tasty-quickcheck, text
}:
mkDerivation {
  pname = "elm-format";
  version = "0.7.0";
  src = fetchgit {
    url = "http://github.com/avh4/elm-format";
    sha256 = "1snl2lrrzdwgzi68agi3sdw84aslj04pzzxpm1mam9ic6dzhn3jf";
    rev = "da4b415c6a2b7e77b7d9f00beca3e45230e603fb";
  };

  doHaddock = false;
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
  jailbreak = true;
  postInstall = ''
    ln -s $out/bin/elm-format-0.18 $out/bin/elm-format
  '';
  postPatch = ''
    sed -i "s|desc <-.*||" ./Setup.hs
    sed -i "s|gitDescribe = .*|gitDescribe = \\\\\"da4b415c\\\\\"\"|" ./Setup.hs
  '';
  homepage = http://elm-lang.org;
  description = "A source code formatter for Elm";
  license = stdenv.lib.licenses.bsd3;
}
