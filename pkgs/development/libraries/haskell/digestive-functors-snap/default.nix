{ cabal, digestiveFunctors, filepath, mtl, snapCore, text }:

cabal.mkDerivation (self: {
  pname = "digestive-functors-snap";
  version = "0.6.0.1";
  sha256 = "0y26fqhjb78mv6rzp3x6cbxrq4dqh2dzd81wd5sgsm079j5frjj7";
  buildDepends = [ digestiveFunctors filepath mtl snapCore text ];
  meta = {
    homepage = "http://github.com/jaspervdj/digestive-functors";
    description = "Snap backend for the digestive-functors library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
