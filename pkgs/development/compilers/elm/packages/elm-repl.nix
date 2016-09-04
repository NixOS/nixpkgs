{ mkDerivation, base, binary, bytestring, bytestring-trie, cmdargs
, containers, directory, elm-compiler, elm-package, fetchgit
, filepath, haskeline, HUnit, mtl, parsec, QuickCheck, stdenv
, test-framework, test-framework-hunit, test-framework-quickcheck2
, text
}:
mkDerivation {
  pname = "elm-repl";
  version = "0.17.1";
  src = fetchgit {
    url = "https://github.com/elm-lang/elm-repl";
    sha256 = "0nh2yfr0bi4rg1kak1gjaczpq56y1nii05b5y7hn6n4w651jkm28";
    rev = "413ac0d4ee43c8542afd3041bbb7b8c903cd3d30";
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
  homepage = "https://github.com/elm-lang/elm-repl";
  description = "a REPL for Elm";
  license = stdenv.lib.licenses.bsd3;
}
