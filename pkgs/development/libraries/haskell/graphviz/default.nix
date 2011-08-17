{ cabal, colour, dlist, extensibleExceptions, fgl, polyparse, text
, transformers, wlPprintText
}:

cabal.mkDerivation (self: {
  pname = "graphviz";
  version = "2999.12.0.3";
  sha256 = "0qvkmklf2wxac6j01fnh8r352b52xzhr8wryk1b9119wvcbli8md";
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
