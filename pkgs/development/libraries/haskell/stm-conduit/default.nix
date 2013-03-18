{ cabal, conduit, resourcet, stm, stmChans, transformers, HUnit, QuickCheck
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2 }:

cabal.mkDerivation (self: {
  pname = "stm-conduit";
  version = "1.0.0";
  sha256 = "1kkx3x3qdqw5jp9vn9kxbxmmb8x0wdbp8jch08azw45pwjh3ga7v";
  buildDepends = [
    conduit resourcet stm stmChans transformers HUnit QuickCheck
    testFramework testFrameworkHunit testFrameworkQuickcheck2
  ];
  meta = {
    homepage = "https://github.com/wowus/stm-conduit";
    description = "Introduces conduits to channels, and promotes using conduits concurrently";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
