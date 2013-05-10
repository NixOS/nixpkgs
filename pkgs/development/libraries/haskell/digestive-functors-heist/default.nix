{ cabal, blazeBuilder, digestiveFunctors, heist, mtl, text, xmlhtml
}:

cabal.mkDerivation (self: {
  pname = "digestive-functors-heist";
  version = "0.6.2.0";
  sha256 = "03wxdmgwc6qialwhp5zdj3s3a8a8yz6vswfgryjx4izaaq7pdhl1";
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
