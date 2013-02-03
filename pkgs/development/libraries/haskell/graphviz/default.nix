{ cabal, colour, dlist, fgl, filepath, polyparse, text
, transformers, wlPprintText
}:

cabal.mkDerivation (self: {
  pname = "graphviz";
  version = "2999.15.0.1";
  sha256 = "137d8n20fbpdz7az79gqharsfl293pl3xn444338i6blfi47ssdy";
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
