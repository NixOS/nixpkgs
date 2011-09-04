{ cabal, blazeHtml, extensibleExceptions, happstackData
, happstackUtil, hslogger, html, MaybeT, mtl, network, parsec
, sendfile, syb, text, time, utf8String, xhtml, zlib
}:

cabal.mkDerivation (self: {
  pname = "happstack-server";
  version = "6.2.2";
  sha256 = "1nrvi3hf689bxvlzc9crav70dmnv3lagafsrc4gmnizqliw6p62g";
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
