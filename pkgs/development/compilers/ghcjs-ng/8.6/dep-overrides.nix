{ haskellLib }:

let inherit (haskellLib) doJailbreak dontHaddock;
in self: super: {
  ghc-api-ghcjs = super.ghc-api-ghcjs.override
  {
    happy = self.happy_1_19_5;
  };
  haddock-library-ghcjs = doJailbreak super.haddock-library-ghcjs;
  haddock-api-ghcjs = doJailbreak (dontHaddock super.haddock-api-ghcjs);
}
