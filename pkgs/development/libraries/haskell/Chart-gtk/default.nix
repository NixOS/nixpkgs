{ cabal, cairo, Chart, ChartCairo, colour, gtk, mtl, time }:

cabal.mkDerivation (self: {
  pname = "Chart-gtk";
  version = "1.2.2";
  sha256 = "1mg6nln0jwp6hals9vhhsfqiwix424fv1v1p4h99s0xwy5cna1z9";
  buildDepends = [ cairo Chart ChartCairo colour gtk mtl time ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/timbod7/haskell-chart/wiki";
    description = "Utility functions for using the chart library with GTK";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
