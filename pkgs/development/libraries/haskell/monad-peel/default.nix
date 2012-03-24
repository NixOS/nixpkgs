{ cabal, extensibleExceptions, transformers }:

cabal.mkDerivation (self: {
  pname = "monad-peel";
  version = "0.1";
  sha256 = "0q56hdjgbj7ykpjx5z8qlqqkngmgm5wzm9vwcd7v675k2ywcl3ys";
  buildDepends = [ extensibleExceptions transformers ];
  meta = {
    homepage = "http://andersk.mit.edu/haskell/monad-peel/";
    description = "Lift control operations like exception catching through monad transformers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
