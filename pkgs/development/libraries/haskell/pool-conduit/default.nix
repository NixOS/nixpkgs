{ cabal, Cabal, conduit, resourcePool, transformers }:

cabal.mkDerivation (self: {
  pname = "pool-conduit";
  version = "0.0.0.1";
  sha256 = "1im5fpwadg9hmajay6dkwmlzbp5rzn8hh9wh01iy23jgivkqk2q0";
  buildDepends = [ Cabal conduit resourcePool transformers ];
  meta = {
    homepage = "http://www.yesodweb.com/book/persistent";
    description = "Resource pool allocations via ResourceT";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
