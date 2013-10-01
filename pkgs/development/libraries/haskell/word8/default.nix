{ cabal, hspec }:

cabal.mkDerivation (self: {
  pname = "word8";
  version = "0.0.4";
  sha256 = "1jrys2crl1yfkgwc4ny6x1kr24kx8j3zsy0zql5ms19rfb0rnkki";
  testDepends = [ hspec ];
  meta = {
    description = "Word8 library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
