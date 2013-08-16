{ cabal, async, conduit, HUnit, monadControl, QuickCheck, resourcet
, stm, stmChans, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, transformers
}:

cabal.mkDerivation (self: {
  pname = "stm-conduit";
  version = "2.1.2";
  sha256 = "1jkjnp1sjb4sqs6zkmmlm0s1126fkh54jkhwxairdwaxx9yh9y9k";
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
