{ cabal, cairo, deepseq, fgl, ghcHeapView, graphviz, gtk, mtl
, svgcairo, text, transformers, xdot
}:

cabal.mkDerivation (self: {
  pname = "ghc-vis";
  version = "0.6.1.1";
  sha256 = "1fg8bxkhw2s3y8w0ljnnqbf8f5ld17p70v4aikc26ybmb0938yl6";
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
