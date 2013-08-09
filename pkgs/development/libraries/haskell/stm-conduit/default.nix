{ cabal, async, conduit, HUnit, monadControl, QuickCheck, resourcet
, stm, stmChans, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, transformers
}:

cabal.mkDerivation (self: {
  pname = "stm-conduit";
  version = "2.1.1";
  sha256 = "06frli37jz9xag249q1gmvnpnsaic1xa304d8d8bjz08980dbmpr";
  buildDepends = [
    async conduit monadControl resourcet stm stmChans transformers
  ];
  testDepends = [
    conduit HUnit QuickCheck stm stmChans testFramework
    testFrameworkHunit testFrameworkQuickcheck2 transformers
  ];
  meta = {
    homepage = "https://github.com/wowus/stm-conduit";
    description = "Introduces conduits to channels, and promotes using conduits concurrently";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
