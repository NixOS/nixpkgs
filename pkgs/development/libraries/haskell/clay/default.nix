{ cabal, HUnit, mtl, testFramework, testFrameworkHunit, text }:

cabal.mkDerivation (self: {
  pname = "clay";
  version = "0.9.0.1";
  sha256 = "1w2617kpj6rblmycqb97gyshwbvzp5w2h4xh494mvdzi3bkahqpn";
  buildDepends = [ mtl text ];
  testDepends = [ HUnit mtl testFramework testFrameworkHunit text ];
  meta = {
    homepage = "http://fvisser.nl/clay";
    description = "CSS preprocessor as embedded Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
