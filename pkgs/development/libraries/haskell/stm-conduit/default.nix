{ cabal, async, conduit, HUnit, liftedAsync, liftedBase
, monadControl, monadLoops, QuickCheck, resourcet, stm, stmChans
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2
, transformers
}:

cabal.mkDerivation (self: {
  pname = "stm-conduit";
  version = "2.1.4";
  sha256 = "0xl3g96blawy5bkvialq6jxnf4wajxb5fg1sh7p9kvw1gvacqwqk";
  buildDepends = [
    async conduit liftedAsync liftedBase monadControl monadLoops
    resourcet stm stmChans transformers
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
