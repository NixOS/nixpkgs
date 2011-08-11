{ cabal }:

cabal.mkDerivation (self: {
  pname = "split";
  version = "0.1.4.1";
  sha256 = "0cdn2sb3m62bnxdz59diwwaxysh3kj4kk1srn4m80p03fj60s0q5";
  meta = {
    homepage = "http://code.haskell.org/~byorgey/code/split";
    description = "Combinator library for splitting lists";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
