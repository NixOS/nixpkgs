{ cabal, bktrees, fgl, filepath, graphviz, pandoc, random, text
, time
}:

cabal.mkDerivation (self: {
  pname = "Graphalyze";
  version = "0.14.0.0";
  sha256 = "027nxvv38cza6y6rivmvc9wpglbazkjrkyriwv3mn03pp21y53fg";
  buildDepends = [
    bktrees fgl filepath graphviz pandoc random text time
  ];
  meta = {
    description = "Graph-Theoretic Analysis library";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
