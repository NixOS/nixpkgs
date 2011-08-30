{ cabal, monadControl, transformers }:

cabal.mkDerivation (self: {
  pname = "pool";
  version = "0.1.1";
  sha256 = "0h498pi7048m4cida10s28dp9f8c2ig3m4s9chwrfw3yiyai926l";
  buildDepends = [ monadControl transformers ];
  meta = {
    homepage = "http://www.yesodweb.com/book/persistent";
    description = "Thread-safe resource pools";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
