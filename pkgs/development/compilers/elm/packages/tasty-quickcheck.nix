{ mkDerivation, base, pcre-light, QuickCheck, random, stdenv
, tagged, tasty, tasty-hunit
}:
mkDerivation {
  pname = "tasty-quickcheck";
  version = "0.9.2";
  sha256 = "c5920adeab6e283d5e3ab45f3c80a1b011bedfbe4a3246a52606da2e1da95873";
  libraryHaskellDepends = [ base QuickCheck random tagged tasty ];
  testHaskellDepends = [ base pcre-light tasty tasty-hunit ];
  doCheck = false;
  homepage = "https://github.com/feuerbach/tasty";
  description = "QuickCheck support for the Tasty test framework";
  license = stdenv.lib.licenses.mit;
}
