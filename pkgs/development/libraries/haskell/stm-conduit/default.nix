{ cabal, async, cereal, cerealConduit, conduit, conduitExtra, HUnit
, liftedAsync, liftedBase, monadControl, monadLoops, QuickCheck
, resourcet, stm, stmChans, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, transformers
}:

cabal.mkDerivation (self: {
  pname = "stm-conduit";
  version = "2.4.0";
  sha256 = "03ifxr3pspwmzf0xdh7mj3q1wiz13d86w9pdhiqa6b1d1qw6rvha";
  buildDepends = [
    async cereal cerealConduit conduit conduitExtra liftedAsync
    liftedBase monadControl monadLoops resourcet stm stmChans
    transformers
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
