{ cabal, bktrees, extensibleExceptions, fgl, graphviz, pandoc
, random, time
}:

cabal.mkDerivation (self: {
  pname = "Graphalyze";
  version = "0.11.0.0";
  sha256 = "1aplfd0qp7ypr9rh4v4x5g8f4b0d1w0dcgz7hgjm9haqcsv37a79";
  buildDepends = [
    bktrees extensibleExceptions fgl graphviz pandoc random time
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
