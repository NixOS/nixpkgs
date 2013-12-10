{ cabal, blazeBuilder, digestiveFunctors, heist, mtl, text, xmlhtml
}:

cabal.mkDerivation (self: {
  pname = "digestive-functors-heist";
  version = "0.8.3.0";
  sha256 = "1im9247mvqngknvkjncjrjj3wydz2k9wlsin53vyddjcqbqxa54g";
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
