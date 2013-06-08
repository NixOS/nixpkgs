{ cabal, extensibleExceptions, transformers }:

cabal.mkDerivation (self: {
  pname = "monad-peel";
  version = "0.1.1";
  sha256 = "0n3cxa94wd3hjvy9jgf3d8p7qfb9jaaf29simjya7rlcb673pg3l";
  buildDepends = [ extensibleExceptions transformers ];
  meta = {
    homepage = "http://andersk.mit.edu/haskell/monad-peel/";
    description = "Lift control operations like exception catching through monad transformers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
