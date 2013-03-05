{ cabal, blazeBuilder, digestiveFunctors, heist, mtl, text, xmlhtml
}:

cabal.mkDerivation (self: {
  pname = "digestive-functors-heist";
  version = "0.6.1.0";
  sha256 = "08h883731cb5kqsv33f6dpf2lgh1r6qn9maqjkn5766vqf7m28nx";
  buildDepends = [
    blazeBuilder digestiveFunctors heist mtl text xmlhtml
  ];
  meta = {
    homepage = "http://github.com/jaspervdj/digestive-functors";
    description = "Heist frontend for the digestive-functors library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
