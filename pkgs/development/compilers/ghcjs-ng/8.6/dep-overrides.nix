{ haskellLib }:

let inherit (haskellLib) doJailbreak dontHaddock;
in self: super: {
  haddock-library-ghcjs = doJailbreak super.haddock-library-ghcjs;
  haddock-api-ghcjs = doJailbreak (dontHaddock super.haddock-api-ghcjs);
}
