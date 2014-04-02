{ cabal, cairo, Chart, ChartCairo, colour, gtk, mtl, time }:

cabal.mkDerivation (self: {
  pname = "Chart-gtk";
  version = "1.2";
  sha256 = "0qq72cf1m2gvcksa1jj5g9qi6b47pmpzh3grhs7kh3m7qyq0a56g";
  buildDepends = [ cairo Chart ChartCairo colour gtk mtl time ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/timbod7/haskell-chart/wiki";
    description = "Utility functions for using the chart library with GTK";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
