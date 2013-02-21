{ cabal }:

cabal.mkDerivation (self: {
  pname = "base64-bytestring";
  version = "1.0.0.1";
  sha256 = "0l1v4ddjdsgi9nqzyzcxxj76rwar3lzx8gmwf2r54bqan3san9db";
  meta = {
    homepage = "https://github.com/bos/base64-bytestring";
    description = "Fast base64 encoding and decoding for ByteStrings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
