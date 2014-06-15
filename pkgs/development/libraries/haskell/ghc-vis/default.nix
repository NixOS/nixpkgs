{ cabal, cairo, deepseq, fgl, ghcHeapView, graphviz, gtk, mtl
, svgcairo, text, transformers, xdot
}:

cabal.mkDerivation (self: {
  pname = "ghc-vis";
  version = "0.7.2.3";
  sha256 = "1gl059n85yxksnq8y7i1vrsjdg4al6himzpdmw95v61y59bbs6c2";
  buildDepends = [
    cairo deepseq fgl ghcHeapView graphviz gtk mtl svgcairo text
    transformers xdot
  ];
  jailbreak = true;
  postInstall = ''
    ensureDir "$out/share/ghci"
    ln -s "$out/share/$pname-$version/ghci" "$out/share/ghci/$pname"
  '';
  meta = {
    homepage = "http://felsin9.de/nnis/ghc-vis";
    description = "Live visualization of data structures in GHCi";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
