{ cabal, haskellSrcExts, text, vector }:

cabal.mkDerivation (self: {
  pname = "lushtags";
  version = "0.0.1";
  sha256 = "0325c064nsczypapvwdchx7x5n69jxjbyjs90ah7q5ydxbjl6w9c";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ haskellSrcExts text vector ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/bitc/lushtags";
    description = "Create ctags compatible tags files for Haskell programs";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
