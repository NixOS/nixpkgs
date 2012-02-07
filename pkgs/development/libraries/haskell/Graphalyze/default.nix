{ cabal, bktrees, extensibleExceptions, fgl, graphviz, pandoc
, random, text, time
}:

cabal.mkDerivation (self: {
  pname = "Graphalyze";
  version = "0.12.0.0";
  sha256 = "0lsbwf08flaifdddbg6d3ndrb2d1wzs943hk7n0m316bvahq6kgx";
  buildDepends = [
    bktrees extensibleExceptions fgl graphviz pandoc random text time
  ];
  patchPhase = ''
    sed -i Graphalyze.cabal -e 's|pandoc == 1.8.\*|pandoc|'
  '';
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
