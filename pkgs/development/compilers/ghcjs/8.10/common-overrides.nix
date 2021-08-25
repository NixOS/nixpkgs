{ haskellLib }:

let inherit (haskellLib) addBuildTools appendConfigureFlag dontHaddock doJailbreak;
in self: super: {
  ghcjs = doJailbreak super.ghcjs;
}
