{ haskellLib }:

let inherit (haskellLib) addBuildTools appendConfigureFlag dontHaddock doJailbreak;
in self: super: {
  ghcjs = doJailbreak (super.ghcjs.overrideScope (self: super: {
    optparse-applicative = self.optparse-applicative_0_15_1_0;
  }));
}
