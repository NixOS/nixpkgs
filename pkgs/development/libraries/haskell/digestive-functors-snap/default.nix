{ cabal, digestiveFunctors, filepath, mtl, snapCore, text }:

cabal.mkDerivation (self: {
  pname = "digestive-functors-snap";
  version = "0.6.0.0";
  sha256 = "18hc0sx7in0df6kgkc8mrxag5h2rmdj2cca9zf9w1if6wimx3g88";
  buildDepends = [ digestiveFunctors filepath mtl snapCore text ];
  meta = {
    homepage = "http://github.com/jaspervdj/digestive-functors";
    description = "Snap backend for the digestive-functors library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
