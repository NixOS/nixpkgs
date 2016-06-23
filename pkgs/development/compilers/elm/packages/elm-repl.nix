{ mkDerivation, base, binary, bytestring, bytestring-trie, cmdargs
, containers, directory, elm-compiler, elm-package, fetchgit
, filepath, haskeline, HUnit, mtl, parsec, QuickCheck, stdenv
, test-framework, test-framework-hunit, test-framework-quickcheck2
}:
mkDerivation {
  pname = "elm-repl";
  version = "0.17";
  src = fetchgit {
    url = "https://github.com/elm-lang/elm-repl";
    sha256 = "0bpmkm7q3a0h4hwlbwcnzaqgf6n5p1qw65z8kw84f52s5bndc0wc";
    rev = "95b4555cff6b6e2a55a4ea3dab00bfb39dfebf0d";
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
  description = "A REPL for Elm";
  license = stdenv.lib.licenses.bsd3;
}
