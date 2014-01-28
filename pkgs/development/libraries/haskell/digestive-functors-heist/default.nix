{ cabal, blazeBuilder, digestiveFunctors, heist, mtl, text, xmlhtml
}:

cabal.mkDerivation (self: {
  pname = "digestive-functors-heist";
  version = "0.8.4.1";
  sha256 = "03bbz5q3asn1iid13xjiv5hdpj5bgr0h9wwp29bnysiw4vrgjax0";
  buildDepends = [
    blazeBuilder digestiveFunctors heist mtl text xmlhtml
  ];
  jailbreak = true;
  meta = {
    homepage = "http://github.com/jaspervdj/digestive-functors";
    description = "Heist frontend for the digestive-functors library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
