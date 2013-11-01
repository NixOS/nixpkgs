{ cabal, mtl, random, transformers }:

cabal.mkDerivation (self: {
  pname = "MonadRandom";
  version = "0.1.12";
  sha256 = "0lr1lvpcj96i6n0w810bjy8k9jygx97nnv0k2zb51d7saw6y95p4";
  buildDepends = [ mtl random transformers ];
  meta = {
    description = "Random-number generation monad";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
