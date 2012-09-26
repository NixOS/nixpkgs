{ cabal, systemFilepath, text, time }:

cabal.mkDerivation (self: {
  pname = "system-fileio";
  version = "0.3.10";
  sha256 = "1f8si6m62nxzj71jgyhxl38szmw8wr3frvgih596vfjxwdhqpkq4";
  buildDepends = [ systemFilepath text time ];
  meta = {
    homepage = "https://john-millikin.com/software/haskell-filesystem/";
    description = "Consistent filesystem interaction across GHC versions";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
