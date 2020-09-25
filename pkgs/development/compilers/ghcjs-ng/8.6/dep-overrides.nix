{ haskellLib }:

let inherit (haskellLib) doJailbreak dontHaddock dontCheck;
in self: super: {
  ghcjs = super.ghcjs.override {
    shelly = super.shelly_1_8_1;
  };
  ghc-api-ghcjs = super.ghc-api-ghcjs.override
  {
    happy = self.happy_1_19_5;
  };
  haddock-library-ghcjs = doJailbreak (dontCheck super.haddock-library-ghcjs);
  haddock-api-ghcjs = doJailbreak (dontHaddock super.haddock-api-ghcjs);
}
