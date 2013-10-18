{ cabal, byteable, cryptoCipherTypes, HUnit, mtl, QuickCheck
, securemem, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "crypto-cipher-tests";
  version = "0.0.10";
  sha256 = "1gmhpk1pdc9axkmpw9fyr1zgv6pskyzzlsq8icp2w4fc83l61smb";
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
