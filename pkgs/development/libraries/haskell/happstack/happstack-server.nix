{ cabal, blazeHtml, extensibleExceptions, filepath, happstackData
, happstackUtil, hslogger, html, MaybeT, mtl, network, parsec
, sendfile, syb, text, time, utf8String, xhtml, zlib
}:

cabal.mkDerivation (self: {
  pname = "happstack-server";
  version = "6.2.5";
  sha256 = "196s8i3v55i10nkapkvzyw048flshw8mlm604548f0qjciynfjmg";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    blazeHtml extensibleExceptions filepath happstackData happstackUtil
    hslogger html MaybeT mtl network parsec sendfile syb text time
    utf8String xhtml zlib
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
