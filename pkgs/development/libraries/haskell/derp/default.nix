{ cabal, Cabal }:

cabal.mkDerivation (self: {
  pname = "derp";
  version = "0.1.5";
  sha256 = "0mpc4hav5iqrcjns5sz8q0v2c0d7nb2hbzn58cmbl7cma2kp36li";
  buildDepends = [ Cabal ];
  meta = {
    description = "Derivative Parsing";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
