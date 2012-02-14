{ cabal, Cabal }:

cabal.mkDerivation (self: {
  pname = "StateVar";
  version = "1.0.0.0";
  sha256 = "1c1b6a6nn1cdnba08zzp0645wl482h7yaa69zw2l3wwyyyccjic4";
  buildDepends = [ Cabal ];
  meta = {
    homepage = "http://www.haskell.org/HOpenGL/";
    description = "State variables";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
