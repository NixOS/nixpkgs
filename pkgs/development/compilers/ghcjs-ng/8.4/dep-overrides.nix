{ haskellLib }:

let inherit (haskellLib) dontCheck doJailbreak;
in self: super: {
  haddock-library-ghcjs = doJailbreak (dontCheck super.haddock-library-ghcjs);
  haddock-api-ghcjs = doJailbreak super.haddock-api-ghcjs;

  template-haskell-ghcjs = doJailbreak super.template-haskell-ghcjs;
}
