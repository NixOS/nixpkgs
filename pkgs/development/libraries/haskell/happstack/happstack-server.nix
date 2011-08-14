{ cabal, blazeHtml, extensibleExceptions, happstackData
, happstackUtil, hslogger, html, MaybeT, mtl, network, parsec
, sendfile, syb, text, time, utf8String, xhtml, zlib
}:

cabal.mkDerivation (self: {
  pname = "happstack-server";
  version = "6.1.6";
  sha256 = "1z4c2bymyyvhs47ynrlp4d2cwqws2d2isiwj82c33qcmk4znargg";
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
