{ cabal, shakespeare, text }:

cabal.mkDerivation (self: {
  pname = "shakespeare-js";
  version = "1.0.1";
  sha256 = "1djv34x2nb634lmv28bm2qfsjr0vs0rlq98y8yaiyjdphkzhlaax";
  buildDepends = [ shakespeare text ];
  meta = {
    homepage = "http://www.yesodweb.com/book/shakespearean-templates";
    description = "Stick your haskell variables into javascript/coffeescript at compile time";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
