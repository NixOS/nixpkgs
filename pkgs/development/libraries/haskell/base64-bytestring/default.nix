{ cabal }:

cabal.mkDerivation (self: {
  pname = "base64-bytestring";
  version = "0.1.2.0";
  sha256 = "039naasb3z8q42zl067paylxb9i1m1pkp4w6b5yqsc38sbmikv1z";
  meta = {
    homepage = "https://github.com/bos/base64-bytestring";
    description = "Fast base64 encoding and deconding for ByteStrings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
