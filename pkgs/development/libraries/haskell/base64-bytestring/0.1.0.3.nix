{ cabal }:

cabal.mkDerivation (self: {
  pname = "base64-bytestring";
  version = "0.1.0.3";
  sha256 = "0d4j8b1d8z9qr1y446bfkj764xgilk8gw2frj0wn0717y8knvmx3";
  meta = {
    homepage = "https://github.com/bos/base64-bytestring";
    description = "Fast base64 encoding and deconding for ByteStrings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
