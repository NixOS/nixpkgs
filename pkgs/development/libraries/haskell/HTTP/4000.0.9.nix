{ cabal, mtl, network, parsec }:

cabal.mkDerivation (self: {
  pname = "HTTP";
  version = "4000.0.9";
  sha256 = "1e2b4a8b782ad1417c8755bb0d248851bc142b351366ed460e07f2945a5e95ba";
  buildDepends = [ mtl network parsec ];
  doCheck = false;
  meta = {
    homepage = "http://projects.haskell.org/http/";
    description = "A library for client-side HTTP";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
