{ mkDerivation, aeson, array, attoparsec, base, binary, bytestring
, containers, deepseq, directory, dlist, fetchgit, ghc-prim
, ghcjs-prim, hashable, HUnit, integer-gmp, primitive, QuickCheck
, quickcheck-unicode, random, scientific, stdenv, test-framework
, test-framework-hunit, test-framework-quickcheck2, text, time
, transformers, unordered-containers, vector
}:
mkDerivation {
  pname = "ghcjs-base";
  version = "0.2.0.3";
  src = fetchgit {
    url = "https://github.com/obsidiansystems/ghcjs-base";
    sha256 = "19bsvv8g4kgjj2z7a8r8in4g8sshvvwn717n4664fnfn6xhzm2i6";
    rev = "ac8887fa77858e6abaecb59b62d15a3b991b6027";
  };
  libraryHaskellDepends = [
    aeson attoparsec base binary bytestring containers deepseq dlist
    ghc-prim ghcjs-prim hashable integer-gmp primitive scientific text
    time transformers unordered-containers vector
  ];
  testHaskellDepends = [
    array base bytestring deepseq directory ghc-prim ghcjs-prim HUnit
    primitive QuickCheck quickcheck-unicode random test-framework
    test-framework-hunit test-framework-quickcheck2 text
  ];
  homepage = "https://github.com/ghcjs/ghcjs-base";
  description = "base library for GHCJS";
  license = stdenv.lib.licenses.mit;
}
