{ cabal, Cabal, mtl }:

cabal.mkDerivation (self: {
  pname = "ppm";
  version = "2009.5.13";
  sha256 = "9e390ca9a9e6e740fa71d2b72fa2c9c3d521118b0ebb35f10fabbbe543ecfb5b";
  buildDepends = [ Cabal mtl ];
  meta = {
    homepage = "http://github.com/nfjinjing/ppm/tree/master";
    description = "a tiny PPM image generator";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
