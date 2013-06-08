{ cabal, mtl, random, transformers }:

cabal.mkDerivation (self: {
  pname = "MonadRandom";
  version = "0.1.9";
  sha256 = "1n947650xlz47rj6y6ik2mknyr9smwragjr5akccinmfm1krg6lz";
  buildDepends = [ mtl random transformers ];
  meta = {
    description = "Random-number generation monad";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
