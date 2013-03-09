{ cabal, cairo, deepseq, fgl, ghcHeapView, graphviz, gtk, mtl
, svgcairo, text, transformers, xdot
}:

cabal.mkDerivation (self: {
  pname = "ghc-vis";
  version = "0.6.1";
  sha256 = "0q0v1l44vagcg0nl4iv8m872g4qblj9syjlcgbf6fpgx1fqnyp24";
  buildDepends = [
    cairo deepseq fgl ghcHeapView graphviz gtk mtl svgcairo text
    transformers xdot
  ];
  meta = {
    homepage = "http://felsin9.de/nnis/ghc-vis";
    description = "Live visualization of data structures in GHCi";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
