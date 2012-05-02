{ cabal, colour, dlist, fgl, filepath, polyparse, text
, transformers, wlPprintText
}:

cabal.mkDerivation (self: {
  pname = "graphviz";
  version = "2999.13.0.2";
  sha256 = "17b95zi8j7mnzrp3kybyfyqqpcdhbf0mdrk0sfnw3qp8fbyfrw1i";
  buildDepends = [
    colour dlist fgl filepath polyparse text transformers wlPprintText
  ];
  meta = {
    homepage = "http://projects.haskell.org/graphviz/";
    description = "Bindings to Graphviz for graph visualisation";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
