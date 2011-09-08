{ cabal, blazeHtml, extensibleExceptions, happstackData
, happstackUtil, hslogger, html, MaybeT, mtl, network, parsec
, sendfile, syb, text, time, utf8String, xhtml, zlib
}:

cabal.mkDerivation (self: {
  pname = "happstack-server";
  version = "6.2.3";
  sha256 = "0rrwzp8il6vfw17m5rqj3ad418k4gxvaa99s817r00iyhna7clmi";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    blazeHtml extensibleExceptions happstackData happstackUtil hslogger
    html MaybeT mtl network parsec sendfile syb text time utf8String
    xhtml zlib
  ];
  meta = {
    homepage = "http://happstack.com";
    description = "Web related tools and services";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
