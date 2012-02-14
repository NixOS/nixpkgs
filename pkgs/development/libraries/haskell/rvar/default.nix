{ cabal, Cabal, MonadPrompt, mtl, randomSource, transformers }:

cabal.mkDerivation (self: {
  pname = "rvar";
  version = "0.2";
  sha256 = "1in2qn1clv9b7ijyllhjflh9zdkna31hpyclhlkfnsc6899z3y1f";
  buildDepends = [ Cabal MonadPrompt mtl randomSource transformers ];
  meta = {
    homepage = "https://github.com/mokus0/random-fu";
    description = "Random Variables";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
