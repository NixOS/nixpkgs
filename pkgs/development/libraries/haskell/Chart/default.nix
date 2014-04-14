{ cabal, colour, dataDefaultClass, lens, mtl, operational, time }:

cabal.mkDerivation (self: {
  pname = "Chart";
  version = "1.2.2";
  sha256 = "0yd3xca500lbzvlvhdsbrkiy53laikq6hc290rc061agvd535a7p";
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
