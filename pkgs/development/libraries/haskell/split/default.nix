{ cabal, Cabal }:

cabal.mkDerivation (self: {
  pname = "split";
  version = "0.1.4.2";
  sha256 = "09vi7vw4i4r78gyp3bbvhvvyiqi8rgf678ppmq99qrfqm34c2fl9";
  buildDepends = [ Cabal ];
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
