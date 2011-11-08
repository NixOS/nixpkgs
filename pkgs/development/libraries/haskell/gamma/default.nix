{ cabal, continuedFractions, converge, vector }:

cabal.mkDerivation (self: {
  pname = "gamma";
  version = "0.9.0.1";
  sha256 = "02s9m2vlrnfg26c7921x60xxmawzzk27y3czcnvs8hlk01mb1xv7";
  buildDepends = [ continuedFractions converge vector ];
  meta = {
    homepage = "https://github.com/mokus0/gamma";
    description = "Gamma function and related functions";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
