{ cabal, colour, dlist, fgl, filepath, polyparse, QuickCheck
, temporary, text, transformers, wlPprintText
}:

cabal.mkDerivation (self: {
  pname = "graphviz";
  version = "2999.17.0.1";
  sha256 = "0s6l1mlqvllrlx7vc06lgcs68ajhfk98awm63ab1dkqmcnj23ixv";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    colour dlist fgl filepath polyparse temporary text transformers
    wlPprintText
  ];
  testDepends = [ fgl filepath QuickCheck text ];
  doCheck = false;
  meta = {
    homepage = "http://projects.haskell.org/graphviz/";
    description = "Bindings to Graphviz for graph visualisation";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
