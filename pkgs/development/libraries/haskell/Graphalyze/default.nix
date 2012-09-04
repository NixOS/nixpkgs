{ cabal, bktrees, fgl, filepath, graphviz, pandoc, random, text
, time
}:

cabal.mkDerivation (self: {
  pname = "Graphalyze";
  version = "0.13.0.1";
  sha256 = "1yk7iglsspbj0kxh5rhjkc6q65vz07vpygiig07w86g2s6gad8am";
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
