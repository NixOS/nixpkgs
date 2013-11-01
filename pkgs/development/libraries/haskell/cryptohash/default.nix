{ cabal, byteable, HUnit, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "cryptohash";
  version = "0.11.1";
  sha256 = "0ww7bikl8i50m1pwkqp145bfsiy07npnjw48j3il4w2ia0b3axmy";
  buildDepends = [ byteable ];
  testDepends = [
    byteable HUnit QuickCheck testFramework testFrameworkHunit
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
