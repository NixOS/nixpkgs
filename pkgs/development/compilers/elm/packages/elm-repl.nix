{ mkDerivation, base, binary, bytestring, bytestring-trie, cmdargs
, containers, directory, elm-compiler, elm-package, fetchgit
, filepath, haskeline, HUnit, mtl, parsec, QuickCheck, stdenv
, test-framework, test-framework-hunit, test-framework-quickcheck2
}:
mkDerivation {
  pname = "elm-repl";
  version = "0.16";
  src = fetchgit {
    url = "https://github.com/elm-lang/elm-repl";
    sha256 = "36d50cf1f86815900afd4b75da6e5cd15008b2652e97ffed0f321a28e6442874";
    rev = "265de7283488964f44f0257a8b4a055ad8af984d";
  };
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base binary bytestring bytestring-trie cmdargs containers directory
    elm-compiler elm-package filepath haskeline mtl parsec
  ];
  testHaskellDepends = [
    base bytestring bytestring-trie cmdargs directory elm-compiler
    elm-package filepath haskeline HUnit mtl parsec QuickCheck
    test-framework test-framework-hunit test-framework-quickcheck2
  ];
  jailbreak = true;
  homepage = "https://github.com/elm-lang/elm-repl";
  description = "a REPL for Elm";
  license = stdenv.lib.licenses.bsd3;
}
