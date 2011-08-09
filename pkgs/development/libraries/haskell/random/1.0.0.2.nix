{ cabal, time }:

cabal.mkDerivation (self: {
  pname = "random";
  version = "1.0.0.2";
  sha256 = "5433aebb4bbfb999f1d02410c8ca3769c63cd8b02109d2771a37c12918f92dd5";
  buildDepends = [ time ];
  meta = {
    description = "random number library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
