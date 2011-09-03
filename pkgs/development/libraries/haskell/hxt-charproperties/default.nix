{ cabal }:

cabal.mkDerivation (self: {
  pname = "hxt-charproperties";
  version = "9.1.0";
  sha256 = "1a227czzbbw8pigc2dk5fyyc4x1rpx82mb5c4hpjjz97l0sdlc23";
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
