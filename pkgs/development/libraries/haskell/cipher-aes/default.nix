{ cabal, byteable, cryptoCipherTests, cryptoCipherTypes, QuickCheck
, securemem, testFramework, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "cipher-aes";
  version = "0.2.6";
  sha256 = "0ys5a1w5pwwr74k9wzcsh1flb2jdcvnp1zz7sjs14jpxclpd8x3i";
  buildDepends = [ byteable cryptoCipherTypes securemem ];
  testDepends = [
    byteable cryptoCipherTests cryptoCipherTypes QuickCheck
    testFramework testFrameworkQuickcheck2
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-cipher-aes";
    description = "Fast AES cipher implementation with advanced mode of operations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
