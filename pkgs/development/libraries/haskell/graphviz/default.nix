{ cabal, colour, dlist, extensibleExceptions, fgl, polyparse, text
, transformers, wlPprintText
}:

cabal.mkDerivation (self: {
  pname = "graphviz";
  version = "2999.12.0.4";
  sha256 = "02yg5c02k3sdrcq5srzpdvlzs6cnrns67576qzr8n7ynhpvard73";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    colour dlist extensibleExceptions fgl polyparse text transformers
    wlPprintText
  ];
  meta = {
    homepage = "http://projects.haskell.org/graphviz/";
    description = "Bindings to Graphviz for graph visualisation";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
