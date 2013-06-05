{ cabal, blazeBuilder, digestiveFunctors, heist, mtl, text, xmlhtml
}:

cabal.mkDerivation (self: {
  pname = "digestive-functors-heist";
  version = "0.7.0.0";
  sha256 = "0ljsr4yy3pb4cjg9dcgfcs9rn1ihg3xi9ak5p3h3kw3w19d1hsaq";
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
