{ cabal, mtl, parsec, syb }:

cabal.mkDerivation (self: {
  pname = "WebBits";
  version = "2.2";
  sha256 = "1frmnjbpgm76dzs1p4766fb6isqc3pxv4dnj8sdhnfliv5j0xv2z";
  buildDepends = [ mtl parsec syb ];
  meta = {
    homepage = "http://github.com/brownplt/webbits";
    description = "JavaScript analysis tools";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
