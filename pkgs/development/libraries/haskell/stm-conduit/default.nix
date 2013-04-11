{ cabal, conduit, HUnit, QuickCheck, resourcet, stm, stmChans
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2
, transformers
}:

cabal.mkDerivation (self: {
  pname = "stm-conduit";
  version = "1.1.0";
  sha256 = "1b5v3vf9izzpw3vaslskhdxqnc1zmag1f3x50dh8r1nl318ndkf7";
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
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
