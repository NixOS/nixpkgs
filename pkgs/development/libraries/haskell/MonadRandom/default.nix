{ cabal, mtl, random, transformers }:

cabal.mkDerivation (self: {
  pname = "MonadRandom";
  version = "0.1.10";
  sha256 = "0acx8vm43pd3wn5gp4rx9h24y08fcdy4bpack1sd0pxx2wmhi5qs";
  buildDepends = [ mtl random transformers ];
  meta = {
    description = "Random-number generation monad";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
