{ cabal, byteable, cereal, cryptoApi, HUnit, QuickCheck, tagged
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "cryptohash";
  version = "0.9.1";
  sha256 = "164j43dja91k2cssh0s2dw9riibijl02bap9mn8jn1h6vjb6w9z0";
  buildDepends = [ byteable cereal cryptoApi tagged ];
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
