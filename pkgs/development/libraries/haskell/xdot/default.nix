{ cabal, cairo, graphviz, gtk, mtl, polyparse, text }:

cabal.mkDerivation (self: {
  pname = "xdot";
  version = "0.2.2";
  sha256 = "1n7lwshfn5rzbk4fxlkn02fxki2xh5m0304hnb1d5mchxyzhfdan";
  buildDepends = [ cairo graphviz gtk mtl polyparse text ];
  meta = {
    description = "Parse Graphviz xdot files and interactively view them using GTK and Cairo";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
