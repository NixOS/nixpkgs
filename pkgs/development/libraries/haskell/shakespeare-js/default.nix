{ cabal, shakespeare, text }:

cabal.mkDerivation (self: {
  pname = "shakespeare-js";
  version = "0.11.2";
  sha256 = "1ck39bgl4wswd88w42b1fx5dlsd7r31d60ssv1lk11x6s4cjihgz";
  buildDepends = [ shakespeare text ];
  meta = {
    homepage = "http://www.yesodweb.com/book/templates";
    description = "Stick your haskell variables into javascript/coffeescript at compile time";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
