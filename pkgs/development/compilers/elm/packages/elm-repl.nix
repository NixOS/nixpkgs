{ mkDerivation, base, binary, bytestring, bytestring-trie, cmdargs
, containers, directory, elm-compiler, elm-package, fetchgit
, filepath, haskeline, HUnit, mtl, parsec, QuickCheck, stdenv
, test-framework, test-framework-hunit, test-framework-quickcheck2
, text
}:
mkDerivation {
  pname = "elm-repl";
  version = "0.18";
  src = fetchgit {
    url = "https://github.com/elm-lang/elm-repl";
    sha256 = "112fzykils4lqz4pc44q4mwvxg0px0zfwx511bfvblrxkwwqlfb5";
    rev = "85f0bcfc28ea6c8a99a360d55c21ff25a556f9fe";
  };
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base binary bytestring bytestring-trie cmdargs containers directory
    elm-compiler elm-package filepath haskeline mtl parsec text
  ];
  testHaskellDepends = [
    base bytestring bytestring-trie cmdargs directory elm-compiler
    elm-package filepath haskeline HUnit mtl parsec QuickCheck
    test-framework test-framework-hunit test-framework-quickcheck2
  ];
  jailbreak = true;
  homepage = https://github.com/elm-lang/elm-repl;
  description = "a REPL for Elm";
  license = stdenv.lib.licenses.bsd3;
}
