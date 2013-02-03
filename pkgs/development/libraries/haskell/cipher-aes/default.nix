{ cabal }:

cabal.mkDerivation (self: {
  pname = "cipher-aes";
  version = "0.1.7";
  sha256 = "1iai9c4rvxframylvc0xwx2nk6s0rsj4dc42wi334xyinilvfyng";
  meta = {
    homepage = "http://github.com/vincenthz/hs-cipher-aes";
    description = "Fast AES cipher implementation with advanced mode of operations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
