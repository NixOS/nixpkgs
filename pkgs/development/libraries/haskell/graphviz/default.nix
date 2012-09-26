{ cabal, colour, dlist, fgl, filepath, polyparse, text
, transformers, wlPprintText
}:

cabal.mkDerivation (self: {
  pname = "graphviz";
  version = "2999.14.1.0";
  sha256 = "13fni5sf6cdfvgyh7kqjjdhmjxkhbgl3gbi0cbq90n8blzg4q1ql";
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
