{ mkDerivation, aeson, array, attoparsec, base, binary, bytestring
, containers, deepseq, directory, dlist, fetchgit, ghc-prim
, ghcjs-prim, hashable, HUnit, integer-gmp, primitive, QuickCheck
, quickcheck-unicode, random, scientific, stdenv, test-framework
, test-framework-hunit, test-framework-quickcheck2, text, time
, transformers, unordered-containers, vector
}:
mkDerivation {
  pname = "ghcjs-base";
  version = "0.2.0.0";
  src = fetchgit {
    url = "git://github.com/ghcjs/ghcjs-base";
    sha256 = "0qr05m0djll3x38dhl85pl798arsndmwfhil8yklhb70lxrbvfrs";
    rev = "01014ade3f8f5ae677df192d7c2a208bd795b96c";
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
