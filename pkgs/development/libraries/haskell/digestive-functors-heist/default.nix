{ cabal, digestiveFunctors, heist, mtl, text, xmlhtml }:

cabal.mkDerivation (self: {
  pname = "digestive-functors-heist";
  version = "0.6.0.0";
  sha256 = "17qndqsk09fvnvyhhw3xbbjjhfyyp4sivc898vqllyyky0wqmrdk";
  buildDepends = [ digestiveFunctors heist mtl text xmlhtml ];
  jailbreak = true;
  meta = {
    homepage = "http://github.com/jaspervdj/digestive-functors";
    description = "Heist frontend for the digestive-functors library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
