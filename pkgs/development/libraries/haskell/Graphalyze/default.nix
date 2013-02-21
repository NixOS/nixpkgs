{ cabal, bktrees, fgl, filepath, graphviz, pandoc, random, text
, time
}:

cabal.mkDerivation (self: {
  pname = "Graphalyze";
  version = "0.14.0.1";
  sha256 = "1prgszkrnb22x9xkwmxbvb9w1h78ffig9268f3q3y65knggmwp1x";
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
