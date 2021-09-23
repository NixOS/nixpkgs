{ haskellLib }:

let inherit (haskellLib) addBuildTools appendConfigureFlag dontHaddock doJailbreak;
in self: super: {
  ghcjs = dontHaddock (appendConfigureFlag (doJailbreak super.ghcjs) "-fno-wrapper-install");
  haddock-library-ghcjs = dontHaddock super.haddock-library-ghcjs;
  system-fileio = doJailbreak super.system-fileio;
}
