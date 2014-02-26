{ cabal, random, time }:

cabal.mkDerivation (self: {
  pname = "abstract-deque";
  version = "0.3";
  sha256 = "18jwswjxwzc9bjiy4ds6hw2a74ki797jmfcifxd2ga4kh7ri1ah9";
  buildDepends = [ random time ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/rrnewton/haskell-lockfree/wiki";
    description = "Abstract, parameterized interface to mutable Deques";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
