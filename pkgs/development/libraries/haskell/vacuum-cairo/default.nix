{ cabal, cairo, deepseq, gtk, strictConcurrency, svgcairo, vacuum
}:

cabal.mkDerivation (self: {
  pname = "vacuum-cairo";
  version = "0.5";
  sha256 = "0jp3xn1h28igcg3xb97ifawx11i7adnyi0ff264w0fril9b8ylwc";
  buildDepends = [
    cairo deepseq gtk strictConcurrency svgcairo vacuum
  ];
  meta = {
    homepage = "http://code.haskell.org/~dons/code/vacuum-cairo";
    description = "Visualize live Haskell data structures using vacuum, graphviz and cairo";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
