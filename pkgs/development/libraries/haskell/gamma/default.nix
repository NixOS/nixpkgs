{ cabal, Cabal, continuedFractions, converge, vector }:

cabal.mkDerivation (self: {
  pname = "gamma";
  version = "0.9.0.2";
  sha256 = "09z4m0qsf1aa2al7x3gl7z3xy6r4m0xqhnz8b917dxa104zw6flq";
  buildDepends = [ Cabal continuedFractions converge vector ];
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
