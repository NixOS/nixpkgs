{ cabal, byteable, HUnit, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "cryptohash";
  version = "0.11.2";
  sha256 = "0az2p7lql1lchl85ca26b5sbvhqsv47daavyfqy84qmr3w3wyr28";
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
