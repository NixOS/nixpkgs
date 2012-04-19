{ cabal, colour, dlist, fgl, filepath, polyparse, text
, transformers, wlPprintText
}:

cabal.mkDerivation (self: {
  pname = "graphviz";
  version = "2999.13.0.1";
  sha256 = "1x6pbcixlqbxcg3dsl9z1f5r0qax2p967z0csqb27am812knakky";
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
