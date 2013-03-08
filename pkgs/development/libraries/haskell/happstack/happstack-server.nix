{ cabal, base64Bytestring, blazeHtml, extensibleExceptions
, filepath, hslogger, html, HUnit, monadControl, mtl, network
, parsec, sendfile, syb, systemFilepath, text, threads, time
, timeCompat, transformers, transformersBase, utf8String, xhtml
, zlib
}:

cabal.mkDerivation (self: {
  pname = "happstack-server";
  version = "7.1.7";
  sha256 = "1gd7qa224z04aya44fdrbhpiy5iw88wjcvqihz6l95ks9ilbzmg7";
  buildDepends = [
    base64Bytestring blazeHtml extensibleExceptions filepath hslogger
    html monadControl mtl network parsec sendfile syb systemFilepath
    text threads time timeCompat transformers transformersBase
    utf8String xhtml zlib
  ];
  testDepends = [ HUnit parsec zlib ];
  doCheck = false;
  meta = {
    homepage = "http://happstack.com";
    description = "Web related tools and services";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
