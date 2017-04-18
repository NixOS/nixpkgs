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
    sha256 = "1mxg99w36b8i43kl1nxp7fd86igi5wyj08m9mraiq58vpcgyqnzq";
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
  description = "a REPL for Elm";
  license = stdenv.lib.licenses.bsd3;
}
