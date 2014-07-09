{ cabal, colour, dataDefaultClass, lens, mtl, operational, time }:

cabal.mkDerivation (self: {
  pname = "Chart";
  version = "1.2.3";
  sha256 = "067bahxig5xyd6zasi74k86qb7bxvbs3shjn9fbslhyckxg50q1j";
  buildDepends = [
    colour dataDefaultClass lens mtl operational time
  ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/timbod7/haskell-chart/wiki";
    description = "A library for generating 2D Charts and Plots";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
