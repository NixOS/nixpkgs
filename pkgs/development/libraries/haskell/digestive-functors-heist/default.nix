{ cabal, digestiveFunctors, heist, mtl, text, xmlhtml }:

cabal.mkDerivation (self: {
  pname = "digestive-functors-heist";
  version = "0.5.1.1";
  sha256 = "0jdg35xrikqg3r0rziv71g619vnmn8fzsv63b73m72fbj5xvy881";
  buildDepends = [ digestiveFunctors heist mtl text xmlhtml ];
  meta = {
    homepage = "http://github.com/jaspervdj/digestive-functors";
    description = "Heist frontend for the digestive-functors library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
