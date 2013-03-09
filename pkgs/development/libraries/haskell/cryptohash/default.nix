{ cabal, cereal, cryptoApi, HUnit, QuickCheck, tagged
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "cryptohash";
  version = "0.8.3";
  sha256 = "1fcqbbclii2hmbhi7h64v0nnbc34zzs107m3lqq38iiyy5fvqqv2";
  buildDepends = [ cereal cryptoApi tagged ];
  testDepends = [
    HUnit QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-cryptohash";
    description = "collection of crypto hashes, fast, pure and practical";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
