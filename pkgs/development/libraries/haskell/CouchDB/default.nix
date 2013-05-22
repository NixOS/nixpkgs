{ cabal, HTTP, HUnit, json, mtl, network, utf8String }:

cabal.mkDerivation (self: {
  pname = "CouchDB";
  version = "1.2";
  sha256 = "0a9g0iblfyqppcy1ni3ac8f3yv5km95bfblhwqlsk6khydi5ka98";
  buildDepends = [ HTTP json mtl network utf8String ];
  testDepends = [ HTTP HUnit json mtl network utf8String ];
  meta = {
    homepage = "http://github.com/arjunguha/haskell-couchdb/";
    description = "CouchDB interface";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
