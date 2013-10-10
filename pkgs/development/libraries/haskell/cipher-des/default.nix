{ cabal, byteable, cryptoCipherTests, cryptoCipherTypes, QuickCheck
, securemem, testFramework, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "cipher-des";
  version = "0.0.5";
  sha256 = "1j4nbmxdc3nb5q9gqmwp40dj7pdy71135kvhvl7dfh6mb18bk22v";
  buildDepends = [ byteable cryptoCipherTypes securemem ];
  testDepends = [
    byteable cryptoCipherTests cryptoCipherTypes QuickCheck
    testFramework testFrameworkQuickcheck2
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-crypto-cipher";
    description = "DES and 3DES primitives";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
