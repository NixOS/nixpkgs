{ cabal, byteable, cryptoCipherTests, cryptoCipherTypes, QuickCheck
, securemem, testFramework, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "cipher-des";
  version = "0.0.6";
  sha256 = "1isazxa2nr1y13y0danfk7wghy34rfpn3f43rw714nk2xk6vrwc5";
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
