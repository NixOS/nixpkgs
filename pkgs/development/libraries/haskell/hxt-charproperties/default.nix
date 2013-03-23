{ cabal }:

cabal.mkDerivation (self: {
  pname = "hxt-charproperties";
  version = "9.1.1";
  sha256 = "14xv0q1hh0k8lgispc4fa49cvyg9s7936kp42vr9b0pyd1q4zid8";
  meta = {
    homepage = "http://www.fh-wedel.de/~si/HXmlToolbox/index.html";
    description = "Character properties and classes for XML and Unicode";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
