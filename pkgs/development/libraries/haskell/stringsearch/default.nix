{ cabal }:

cabal.mkDerivation (self: {
  pname = "stringsearch";
  version = "0.3.6.4";
  sha256 = "16g0x0n8x3bg3mij7w3r5m3h2i2dn3bd298n14iccdwhfnlzm91b";
  meta = {
    homepage = "https://bitbucket.org/dafis/stringsearch";
    description = "Fast searching, splitting and replacing of ByteStrings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
