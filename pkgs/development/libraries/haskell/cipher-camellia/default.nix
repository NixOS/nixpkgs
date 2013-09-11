{ cabal, byteable, cryptoCipherTests, cryptoCipherTypes, QuickCheck
, securemem, testFramework, testFrameworkQuickcheck2, vector
}:

cabal.mkDerivation (self: {
  pname = "cipher-camellia";
  version = "0.0.1";
  sha256 = "11narl4h77v7317hdqy8zxhym3k7xrmw97yfwh0vr8k1y5dkiqh3";
  buildDepends = [ byteable cryptoCipherTypes securemem vector ];
  testDepends = [
    byteable cryptoCipherTests cryptoCipherTypes QuickCheck
    testFramework testFrameworkQuickcheck2
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-crypto-cipher";
    description = "Camellia block cipher primitives";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
