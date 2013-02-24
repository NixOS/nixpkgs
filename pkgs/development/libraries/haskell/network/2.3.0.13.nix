{ cabal, HUnit, parsec, testFramework, testFrameworkHunit }:

cabal.mkDerivation (self: {
  pname = "network";
  version = "2.3.0.13";
  sha256 = "0xw53czvcw8k49aqxmchc1rcd6pyxp4icwgp64625fnm3l4yjiq7";
  buildDepends = [ parsec ];
  testDepends = [ HUnit testFramework testFrameworkHunit ];
  meta = {
    homepage = "http://github.com/haskell/network";
    description = "Low-level networking interface";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
