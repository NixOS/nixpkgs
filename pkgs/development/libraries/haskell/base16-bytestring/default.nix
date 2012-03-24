{ cabal }:

cabal.mkDerivation (self: {
  pname = "base16-bytestring";
  version = "0.1.1.4";
  sha256 = "061rxlw5kjwj0s08kml46qpw602xwwp05285gpad8c7baw5mzxlr";
  meta = {
    homepage = "http://github.com/bos/base16-bytestring";
    description = "Fast base16 (hex) encoding and decoding for ByteStrings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
