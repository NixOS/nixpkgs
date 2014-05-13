{ cabal, cairo, deepseq, fgl, ghcHeapView, graphviz, gtk, mtl
, svgcairo, text, transformers, xdot
}:

cabal.mkDerivation (self: {
  pname = "ghc-vis";
  version = "0.7.2.1";
  sha256 = "160b45bgiz2ckva70dnmkf6i9bvffaavm5wzia2lk8c65pnvc9ih";
  buildDepends = [
    cairo deepseq fgl ghcHeapView graphviz gtk mtl svgcairo text
    transformers xdot
  ];
  postInstall = ''
    ensureDir "$out/share/ghci"
    ln -s "$out/share/$pname-$version/ghci" "$out/share/ghci/$pname"
  '';
  jailbreak = true;
  meta = {
    homepage = "http://felsin9.de/nnis/ghc-vis";
    description = "Live visualization of data structures in GHCi";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
