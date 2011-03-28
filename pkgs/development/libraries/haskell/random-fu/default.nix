{cabal, erf, mtl, mersenneRandomPure64, monadLoops, MonadPrompt,
 mwcRandom, randomShuffle, stateref, tagged, vector, syb}:

cabal.mkDerivation (self : {
  pname = "random-fu";
  version = "0.1.3";
  sha256 = "1l7czlll6y02m5xzdky95m78806gnj5y3nk3cxs5zqgxwskq73bk";
  propagatedBuildInputs =
    [erf mtl mersenneRandomPure64 monadLoops MonadPrompt
     mwcRandom randomShuffle stateref tagged vector syb];
  meta = {
    description = "Random number generation";
    license = "Public Domain";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

