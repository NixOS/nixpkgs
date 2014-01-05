{ cabal, mtl, transformers }:

cabal.mkDerivation (self: {
  pname = "statestack";
  version = "0.2";
  sha256 = "0j1axjwlh270qy6nlvm0hbc8nbd1ggm7klkjv553qf1rprz4zc2d";
  buildDepends = [ mtl transformers ];
  meta = {
    description = "Simple State-like monad transformer with saveable and restorable state";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
