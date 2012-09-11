{ cabal }:

cabal.mkDerivation (self: {
  pname = "cipher-aes";
  version = "0.1.1";
  sha256 = "0pyiqsdvvq0qhlin17rijqjq0sc0i9nl9rdwbql01fr4pw46cwwg";
  isLibrary = true;
  isExecutable = true;
  meta = {
    homepage = "http://github.com/vincenthz/hs-cipher-aes";
    description = "Fast AES cipher implementation with advanced mode of operations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
