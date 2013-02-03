{ cabal }:

cabal.mkDerivation (self: {
  pname = "base64-bytestring";
  version = "1.0.0.0";
  sha256 = "0z0r0lrpka3qrq45ajzyxsjc2as7zp6bq7z7sd56rwiziw7vp7vm";
  meta = {
    homepage = "https://github.com/bos/base64-bytestring";
    description = "Fast base64 encoding and deconding for ByteStrings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
