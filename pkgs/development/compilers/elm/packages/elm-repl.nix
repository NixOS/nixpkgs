{ mkDerivation, base, binary, bytestring, bytestring-trie, cmdargs
, containers, directory, elm-compiler, elm-package, fetchgit
, filepath, haskeline, HUnit, mtl, parsec, process, QuickCheck
, stdenv, test-framework, test-framework-hunit
, test-framework-quickcheck2
}:
mkDerivation {
  pname = "elm-repl";
  version = "0.4.2";
  src = fetchgit {
    url = "https://github.com/elm-lang/elm-repl";
    sha256 = "a6eadbef7886c4c65243723f101910909bb0d53b2c48454ed7b39cf700f9649c";
    rev = "0c434fdb24b86a93b06c33c8f26857ce47caf165";
  };
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    base binary bytestring bytestring-trie cmdargs containers directory
    elm-compiler elm-package filepath haskeline mtl parsec process
  ];
  testDepends = [
    base bytestring bytestring-trie cmdargs directory elm-compiler
    elm-package filepath haskeline HUnit mtl parsec process QuickCheck
    test-framework test-framework-hunit test-framework-quickcheck2
  ];
  jailbreak = true;
  homepage = "https://github.com/elm-lang/elm-repl";
  description = "a REPL for Elm";
  license = stdenv.lib.licenses.bsd3;
}
