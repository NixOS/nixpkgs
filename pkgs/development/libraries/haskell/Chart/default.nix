{ cabal, colour, dataDefaultClass, lens, mtl, operational, time }:

cabal.mkDerivation (self: {
  pname = "Chart";
  version = "1.0";
  sha256 = "137njda84vxrj3pk12bmkf11wh8fj89nxpz067wrycrgw9xy5rd3";
  buildDepends = [
    colour dataDefaultClass lens mtl operational time
  ];
  meta = {
    homepage = "https://github.com/timbod7/haskell-chart/wiki";
    description = "A library for generating 2D Charts and Plots";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
