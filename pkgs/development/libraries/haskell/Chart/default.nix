{ cabal, colour, dataDefaultClass, lens, mtl, operational, time }:

cabal.mkDerivation (self: {
  pname = "Chart";
  version = "1.1";
  sha256 = "136s44mbhf3wmg85rr9qr0kv59lq1lfd3l58a5aijpv9vz1isf7p";
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
