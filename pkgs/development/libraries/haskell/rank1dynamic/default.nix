{ cabal, binary }:

cabal.mkDerivation (self: {
  pname = "rank1dynamic";
  version = "0.1.0.1";
  sha256 = "18rlih5bndlm5v4nnv8g2rgvab5n22vd8mcjd0m4wq8fmqkb3x9d";
  buildDepends = [ binary ];
  meta = {
    homepage = "http://github.com/haskell-distributed/distributed-process";
    description = "Like Data.Dynamic/Data.Typeable but with support for rank-1 polymorphic types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
