{ cabal, colour, dlist, fgl, filepath, polyparse, text
, transformers, wlPprintText
}:

cabal.mkDerivation (self: {
  pname = "graphviz";
  version = "2999.13.0.3";
  sha256 = "0rwjlwfa3s1vgh5mwzwmzq4s153iq338zy7jqi0qyxcs52illqq8";
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
