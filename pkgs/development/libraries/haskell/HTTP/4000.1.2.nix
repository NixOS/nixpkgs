{ cabal, mtl, network, parsec }:

cabal.mkDerivation (self: {
  pname = "HTTP";
  version = "4000.1.2";
  sha256 = "19vcy8xinrvn01caly6sg1p1yvbbf7nwq10kxmnwqssnl4h5cwn8";
  buildDepends = [ mtl network parsec ];
  meta = {
    homepage = "http://projects.haskell.org/http/";
    description = "A library for client-side HTTP";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
