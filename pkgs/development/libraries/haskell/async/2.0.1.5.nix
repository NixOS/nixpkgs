{ cabal, HUnit, stm, testFramework, testFrameworkHunit }:

cabal.mkDerivation (self: {
  pname = "async";
  version = "2.0.1.5";
  sha256 = "0g587b64zgn971qb2lh846ihg4z89037f18821kyaqsgixasq4yd";
  buildDepends = [ stm ];
  testDepends = [ HUnit testFramework testFrameworkHunit ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/simonmar/async";
    description = "Run IO operations asynchronously and wait for their results";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
