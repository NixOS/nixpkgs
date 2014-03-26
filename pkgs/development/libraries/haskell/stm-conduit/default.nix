{ cabal, async, cereal, cerealConduit, conduit, HUnit, liftedAsync
, liftedBase, monadControl, monadLoops, QuickCheck, resourcet, stm
, stmChans, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, transformers
}:

cabal.mkDerivation (self: {
  pname = "stm-conduit";
  version = "2.3.0";
  sha256 = "1qvzqzk822sc0sjblgqb5y73mggsvh70zpzz908isfiqcwp7llc4";
  buildDepends = [
    async cereal cerealConduit conduit liftedAsync liftedBase
    monadControl monadLoops resourcet stm stmChans transformers
  ];
  testDepends = [
    conduit HUnit QuickCheck resourcet stm stmChans testFramework
    testFrameworkHunit testFrameworkQuickcheck2 transformers
  ];
  meta = {
    homepage = "https://github.com/wowus/stm-conduit";
    description = "Introduces conduits to channels, and promotes using conduits concurrently";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
