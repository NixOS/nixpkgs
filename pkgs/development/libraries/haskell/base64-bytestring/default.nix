{ cabal }:

cabal.mkDerivation (self: {
  pname = "base64-bytestring";
  version = "0.1.1.1";
  sha256 = "0j0jns0yf7dv2bx91hayc8hx0pdab7rhkjllmkl8019kf8rx3gwd";
  meta = {
    homepage = "https://github.com/bos/base64-bytestring";
    description = "Fast base64 encoding and deconding for ByteStrings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
