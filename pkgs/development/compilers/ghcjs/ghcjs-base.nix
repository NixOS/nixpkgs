{ mkDerivation, aeson, array, attoparsec, base, binary, bytestring
, containers, deepseq, directory, dlist, fetchFromGitHub, ghc-prim
, ghcjs-prim, hashable, HUnit, integer-gmp, primitive, QuickCheck
, quickcheck-unicode, random, scientific, test-framework
, test-framework-hunit, test-framework-quickcheck2, text, time
, transformers, unordered-containers, vector
, lib
}:
mkDerivation {
  pname = "ghcjs-base";
  version = "0.2.0.3";
  src = fetchFromGitHub {
    owner = "ghcjs";
    repo = "ghcjs-base";
    rev = "85e31beab9beffc3ea91b954b61a5d04e708b8f2";
    sha256 = "sha256-YDOfi/WZz/602OtbY8wL5jX3X+9oiGL1WhceCraczZU=";
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
  license = lib.licenses.mit;
}
