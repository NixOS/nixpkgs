{ cabal, cairo, Chart, ChartCairo, colour, gtk, mtl, time }:

cabal.mkDerivation (self: {
  pname = "Chart-gtk";
  version = "1.1";
  sha256 = "1394h7jd8pk55396nz1xjisz4v7brqcf9fwdnw9g4q3x1b7dcgs8";
  buildDepends = [ cairo Chart ChartCairo colour gtk mtl time ];
  meta = {
    homepage = "https://github.com/timbod7/haskell-chart/wiki";
    description = "Utility functions for using the chart library with GTK";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
