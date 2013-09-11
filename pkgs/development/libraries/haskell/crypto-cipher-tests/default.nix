{ cabal, byteable, cryptoCipherTypes, HUnit, mtl, QuickCheck
, securemem, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "crypto-cipher-tests";
  version = "0.0.4";
  sha256 = "1c725zj94d6n33wldyzlm1qd32a0ais0w221ykpgs49rrd6hrpbh";
  buildDepends = [
    byteable cryptoCipherTypes HUnit mtl QuickCheck securemem
    testFramework testFrameworkHunit testFrameworkQuickcheck2
  ];
  testDepends = [
    byteable cryptoCipherTypes HUnit mtl QuickCheck testFramework
    testFrameworkHunit testFrameworkQuickcheck2
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-crypto-cipher";
    description = "Generic cryptography cipher tests";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
