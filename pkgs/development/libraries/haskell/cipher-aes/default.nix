{ cabal }:

cabal.mkDerivation (self: {
  pname = "cipher-aes";
  version = "0.1.5";
  sha256 = "0n0qbq2hwyksdbr6fn7yj5vwicmdrn58mfz0dprl8fj456r4j3kn";
  meta = {
    homepage = "http://github.com/vincenthz/hs-cipher-aes";
    description = "Fast AES cipher implementation with advanced mode of operations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
