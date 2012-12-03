{ cabal }:

cabal.mkDerivation (self: {
  pname = "cipher-aes";
  version = "0.1.4";
  sha256 = "0yidq4swwhn1ldm16faraa00gpy946r9ndjkwhfps4pb3h96z0hz";
  meta = {
    homepage = "http://github.com/vincenthz/hs-cipher-aes";
    description = "Fast AES cipher implementation with advanced mode of operations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
