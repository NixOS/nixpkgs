{ cabal, bktrees, fgl, filepath, graphviz, pandoc, random, text
, time
}:

cabal.mkDerivation (self: {
  pname = "Graphalyze";
  version = "0.13.0.0";
  sha256 = "1xh6xg2rw43cbi83rmpb0c2yib9cfj0pwg66nx5x5a0al2c9pdsr";
  buildDepends = [
    bktrees fgl filepath graphviz pandoc random text time
  ];
  meta = {
    description = "Graph-Theoretic Analysis library";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
