{ cabal, digestiveFunctors, filepath, mtl, snapCore, text }:

cabal.mkDerivation (self: {
  pname = "digestive-functors-snap";
  version = "0.5.0.1";
  sha256 = "149c01vxzlwskqsncc5l26mk67icmsq2zbav2asjxpp6z8b53i3b";
  buildDepends = [ digestiveFunctors filepath mtl snapCore text ];
  meta = {
    homepage = "http://github.com/jaspervdj/digestive-functors";
    description = "Snap backend for the digestive-functors library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
