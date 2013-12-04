{ cabal, colour, dlist, fgl, filepath, polyparse, QuickCheck
, temporary, text, transformers, wlPprintText
}:

cabal.mkDerivation (self: {
  pname = "graphviz";
  version = "2999.16.0.0";
  sha256 = "1g4q4wyj5amz9xvgnqn143p5nq6m4a0lggxz7jn9l2hwp41bx1g8";
  buildDepends = [
    colour dlist fgl filepath polyparse temporary text transformers
    wlPprintText
  ];
  testDepends = [
    colour dlist fgl filepath polyparse QuickCheck temporary text
    transformers wlPprintText
  ];
  patchPhase = ''
    sed -i -e 's|polyparse.*,|polyparse,|' -e 's|dlist ==.*|dlist|' graphviz.cabal
  '';
  doCheck = false;
  meta = {
    homepage = "http://projects.haskell.org/graphviz/";
    description = "Bindings to Graphviz for graph visualisation";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
