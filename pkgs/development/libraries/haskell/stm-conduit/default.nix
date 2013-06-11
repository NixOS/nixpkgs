{ cabal, conduit, HUnit, QuickCheck, resourcet, stm, stmChans
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2
, transformers
}:

cabal.mkDerivation (self: {
  pname = "stm-conduit";
  version = "2.1.0";
  sha256 = "0rxnw7kpxvhwmpbn2v9ps0b2hw9321817nyywjjq3x8fadg8w99l";
  buildDepends = [ conduit resourcet stm stmChans transformers ];
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
