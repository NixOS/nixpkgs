{ cabal }:

cabal.mkDerivation (self: {
  pname = "terminal-size";
  version = "0.2.1.0";
  sha256 = "0d41af1is3vdb1kgd8dk82fags86bgs67vkbzpdhjdwa3aimsxgn";
  meta = {
    description = "Get terminal window height and width";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
