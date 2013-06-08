{ cabal, HUnit, parsec, testFramework, testFrameworkHunit }:

cabal.mkDerivation (self: {
  pname = "network";
  version = "2.3.1.0";
  sha256 = "1fp25wkl5cc4kx0jv5w02b7pzgqadjg1yrknzzwsqxc5s3cpyz6l";
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
