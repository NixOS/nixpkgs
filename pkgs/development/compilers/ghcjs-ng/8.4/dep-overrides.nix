{ haskellLib }:

let inherit (haskellLib) dontCheck doJailbreak;
in self: super: {
  haddock-library-ghcjs = dontCheck super.haddock-library-ghcjs;
  haddock-api-ghcjs = doJailbreak super.haddock-api-ghcjs;
}
