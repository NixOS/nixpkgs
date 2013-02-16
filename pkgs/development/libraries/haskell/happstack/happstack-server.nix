{ cabal, base64Bytestring, blazeHtml, extensibleExceptions
, filepath, hslogger, html, monadControl, mtl, network, parsec
, sendfile, syb, systemFilepath, text, threads, time, timeCompat
, transformers, transformersBase, utf8String, xhtml, zlib
}:

cabal.mkDerivation (self: {
  pname = "happstack-server";
  version = "7.1.4";
  sha256 = "0vnawm2m7lr7yvpd30divczxl90fayjvsysr7l1lq76qgxjsd576";
  buildDepends = [
    base64Bytestring blazeHtml extensibleExceptions filepath hslogger
    html monadControl mtl network parsec sendfile syb systemFilepath
    text threads time timeCompat transformers transformersBase
    utf8String xhtml zlib
  ];
  meta = {
    homepage = "http://happstack.com";
    description = "Web related tools and services";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
