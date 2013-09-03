{ cabal, cairo, Chart, ChartCairo, colour, gtk, mtl, time }:

cabal.mkDerivation (self: {
  pname = "Chart-gtk";
  version = "1.0";
  sha256 = "06i53922hdc7dvh2a76ccvwrwfhvhji0ya8j4f2lddg5zckvp3yj";
  buildDepends = [ cairo Chart ChartCairo colour gtk mtl time ];
  meta = {
    homepage = "https://github.com/timbod7/haskell-chart/wiki";
    description = "Utility functions for using the chart library with GTK";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
