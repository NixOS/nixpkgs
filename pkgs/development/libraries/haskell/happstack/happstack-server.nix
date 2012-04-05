{ cabal, base64Bytestring, blazeHtml, extensibleExceptions
, filepath, hslogger, html, monadControl, mtl, network, parsec
, sendfile, syb, text, time, transformers, transformersBase
, utf8String, xhtml, zlib
}:

cabal.mkDerivation (self: {
  pname = "happstack-server";
  version = "7.0.0";
  sha256 = "09i573gracz04z8b5rls7jm6hq5dfg7a4gkn7xpfsl1nmhnf1xhv";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    base64Bytestring blazeHtml extensibleExceptions filepath hslogger
    html monadControl mtl network parsec sendfile syb text time
    transformers transformersBase utf8String xhtml zlib
  ];
  meta = {
    homepage = "http://happstack.com";
    description = "Web related tools and services";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
