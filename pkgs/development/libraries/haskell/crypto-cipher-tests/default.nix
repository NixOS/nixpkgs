{ cabal, byteable, cryptoCipherTypes, HUnit, mtl, QuickCheck
, securemem, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "crypto-cipher-tests";
  version = "0.0.7";
  sha256 = "1qlb3qr6hnla0aayyjmi5r7m7w5vy1wx8yd9cl9cpzr8wviy4lch";
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
