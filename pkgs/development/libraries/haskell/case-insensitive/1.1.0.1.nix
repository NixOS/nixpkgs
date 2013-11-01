{ cabal, deepseq, hashable, HUnit, testFramework
, testFrameworkHunit, text
}:

cabal.mkDerivation (self: {
  pname = "case-insensitive";
  version = "1.1.0.1";
  sha256 = "1hwkdkpr88r3s7c8w1msw1pawz8cfi0lwj1z9dcsp0xs788yzapp";
  buildDepends = [ deepseq hashable text ];
  testDepends = [ HUnit testFramework testFrameworkHunit text ];
  meta = {
    homepage = "https://github.com/basvandijk/case-insensitive";
    description = "Case insensitive string comparison";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
