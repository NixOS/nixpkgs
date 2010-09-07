{cabal, HUnit, HaXml, MaybeT, parsec, sendfile, utf8String, mtl, network, hslogger, happstackData, happstackUtil, xhtml, html, zlib}:

cabal.mkDerivation (self : {
    pname = "happstack-server";
    version = "0.5.0.2";
    sha256 = "0184c835958bf9f29009a5aedd2c913bb1ad6ab60b80d9750849381c172dd6b6";
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
