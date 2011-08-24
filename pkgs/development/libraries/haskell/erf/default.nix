{ cabal }:

cabal.mkDerivation (self: {
  pname = "erf";
  version = "2.0.0.0";
  sha256 = "0dxk2r32ajmmc05vaxcp0yw6vgv4lkbmh8jcshncn98xgsfbgw14";
  meta = {
    description = "The error function, erf, and related functions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
