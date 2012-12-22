{ cabal, binary }:

cabal.mkDerivation (self: {
  pname = "rank1dynamic";
  version = "0.1.0.2";
  sha256 = "1341hhbdm6y0mj0qjda0ckqsla51fxiy1yfpbwfvsmpi2bkzgxn6";
  buildDepends = [ binary ];
  meta = {
    homepage = "http://github.com/haskell-distributed/distributed-process";
    description = "Like Data.Dynamic/Data.Typeable but with support for rank-1 polymorphic types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
