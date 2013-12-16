{ cabal, prettyShow, text }:

cabal.mkDerivation (self: {
  pname = "assert-failure";
  version = "0.1";
  sha256 = "1xwd6rhka9gzmldkaw3d7262h51wxw9dwgip39q8pjkvvfs5kwkr";
  buildDepends = [ prettyShow text ];
  meta = {
    homepage = "https://github.com/Mikolaj/assert-failure";
    description = "Syntactic sugar improving 'assert' and 'error'";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
