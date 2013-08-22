{ cabal, byteable, cryptoCipherTypes, HUnit, mtl, QuickCheck
, securemem, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "crypto-cipher-tests";
  version = "0.0.2";
  sha256 = "1jzci2a6827jgiklj8sh7pjl7g4igk2j6mim20619i4rk6x0lhgz";
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
