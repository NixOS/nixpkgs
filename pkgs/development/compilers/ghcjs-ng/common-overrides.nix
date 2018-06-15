{ haskellLib, alex, happy }:

let inherit (haskellLib) addBuildTools appendConfigureFlag dontHaddock doJailbreak;
in self: super: {
  ghc-api-ghcjs = addBuildTools super.ghc-api-ghcjs [alex happy];
  ghcjs = dontHaddock (appendConfigureFlag (doJailbreak super.ghcjs) "-fno-wrapper-install");
  haddock-library-ghcjs = dontHaddock super.haddock-library-ghcjs;
}
