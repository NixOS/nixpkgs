{ cabal, shakespeare, text }:

cabal.mkDerivation (self: {
  pname = "shakespeare-js";
  version = "0.10.2";
  sha256 = "1yyqfp2lj8vq7x2a74wrgm7kx6zp1djp67bls9ip74kxi24dbznv";
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
