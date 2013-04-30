{ cabal, cairo, deepseq, fgl, ghcHeapView, graphviz, gtk, mtl
, svgcairo, text, transformers, xdot
}:

cabal.mkDerivation (self: {
  pname = "ghc-vis";
  version = "0.7.0.1";
  sha256 = "0k6pm1lqmcmgdqzcdbygdyg6bgx4k0gi77k1mxwprgr9vv3ly26w";
  buildDepends = [
    cairo deepseq fgl ghcHeapView graphviz gtk mtl svgcairo text
    transformers xdot
  ];
  meta = {
    homepage = "http://felsin9.de/nnis/ghc-vis";
    description = "Live visualization of data structures in GHCi";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
