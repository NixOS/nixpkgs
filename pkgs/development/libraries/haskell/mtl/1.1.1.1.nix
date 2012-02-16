{ cabal, Cabal }:

cabal.mkDerivation (self: {
  pname = "mtl";
  version = "1.1.1.1";
  sha256 = "157gbrgrg0l9r72nq45dkach53yncysif4qglsaql28g37djc4x6";
  buildDepends = [ Cabal ];
  meta = {
    description = "Monad transformer library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
