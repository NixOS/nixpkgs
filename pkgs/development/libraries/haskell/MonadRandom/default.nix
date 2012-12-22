{ cabal, mtl, random }:

cabal.mkDerivation (self: {
  pname = "MonadRandom";
  version = "0.1.8";
  sha256 = "1zin7qyv86gza60q6a6r8az2dwxm80wh23idvmjapgbjn2kfvfim";
  buildDepends = [ mtl random ];
  meta = {
    description = "Random-number generation monad";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
