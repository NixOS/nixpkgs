{cabal, HUnit, HaXml, MaybeT, parsec, sendfile, utf8String, mtl, network, hslogger, happstackData, happstackUtil, xhtml, html, zlib}:

cabal.mkDerivation (self : {
    pname = "happstack-server";
    version = "0.4.1";
    sha256 = "2a5d32b4e635160ffab8a90891d9c5ca0433969944ae4013ec8cebe25ba63658";
    propagatedBuildInputs = [
      HUnit HaXml MaybeT happstackData happstackUtil hslogger html
      mtl network parsec sendfile utf8String xhtml zlib
    ];
    meta = {
        description = "Web related tools and services";
        license = "BSD";
        maintainers = [self.stdenv.lib.maintainers.andres];
    };
})
