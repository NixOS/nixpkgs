{ cabal, mtl, QuickCheck, Stream }:

cabal.mkDerivation (self: {
  pname = "IOSpec";
  version = "0.2.5";
  sha256 = "0r6vqg39h6vzwlb33cvk72k4mh6jd8rpdcnkqsfxdqmsk7h8x84j";
  buildDepends = [ mtl QuickCheck Stream ];
  meta = {
    description = "A pure specification of the IO monad";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
