{ cabal }:

cabal.mkDerivation (self: {
  pname = "base64-bytestring";
  version = "0.1.1.3";
  sha256 = "0gyms4nf5j9ick1l5ys9h7h0nxpsi5vgs4dbynrqyhm9yd09cscg";
  meta = {
    homepage = "https://github.com/bos/base64-bytestring";
    description = "Fast base64 encoding and deconding for ByteStrings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
