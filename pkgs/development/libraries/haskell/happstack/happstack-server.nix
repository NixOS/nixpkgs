{cabal, HUnit, HaXml, MaybeT, parsec, sendfile, utf8String, mtl, network, hslogger, happstackData, happstackUtil, xhtml, html, zlib}:

cabal.mkDerivation (self : {
    pname = "happstack-server";
    version = "0.5.0.4";
    sha256 = "1iyjrlg5x6rlx8bfhn62a0ckjap0zv22hb6yazqph53jx6vn9b7q";
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
