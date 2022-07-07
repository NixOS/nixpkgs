{ mkDerivation, fetchpatch, ansi-terminal, ansi-wl-pprint, base, binary
, bytestring, Cabal, cmark, containers, directory, elm-format
, fetchgit, filepath, free, HUnit, indents, json, mtl
, optparse-applicative, parsec, process, QuickCheck, quickcheck-io
, split, lib, tasty, tasty-golden, tasty-hunit, tasty-quickcheck
, text
}:
mkDerivation {
  pname = "elm-instrument";
  version = "0.0.7";
  src = fetchgit {
    url = "https://github.com/zwilias/elm-instrument";
    sha256 = "167d7l2547zxdj7i60r6vazznd9ichwc0bqckh3vrh46glkz06jv";
    rev = "63e15bb5ec5f812e248e61b6944189fa4a0aee4e";
    fetchSubmodules = true;
  };
  patches = [
    # Update code after breaking change in optparse-applicative
    # https://github.com/zwilias/elm-instrument/pull/5
    (fetchpatch {
      name = "update-optparse-applicative.patch";
      url = "https://github.com/mdevlamynck/elm-instrument/commit/c548709d4818aeef315528e842eaf4c5b34b59b4.patch";
      sha256 = "0ln7ik09n3r3hk7jmwwm46kz660mvxfa71120rkbbaib2falfhsc";
    })
  ];
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
  homepage = "https://elm-lang.org";
  description = "Instrumentation library for Elm";
  license = lib.licenses.bsd3;
}
