{ cabal }:

cabal.mkDerivation (self: {
  pname = "split";
  version = "0.1.4.3";
  sha256 = "1i9vmb0zvmhqj6qcbnsapsk9lhsyzznz336c8s7v4sz20s99hsby";
  meta = {
    homepage = "http://code.haskell.org/~byorgey/code/split";
    description = "Combinator library for splitting lists";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
