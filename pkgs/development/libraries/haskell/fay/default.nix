{ cabal, aeson, attoparsec, Cabal, cpphs, dataDefault, filepath
, ghcPaths, haskellNames, haskellPackages, haskellSrcExts, HUnit
, languageEcmascript, mtl, optparseApplicative, prettyShow, safe
, sourcemap, split, syb, testFramework, testFrameworkHunit
, testFrameworkTh, text, time, uniplate, unorderedContainers
, utf8String, vector
}:

cabal.mkDerivation (self: {
  pname = "fay";
  version = "0.18.1.3";
  sha256 = "1m747l2555w1jkdwh8b851mxvngiy7l7sbkwvm2il6k5ygcz5gbv";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson attoparsec Cabal cpphs dataDefault filepath ghcPaths
    haskellNames haskellPackages haskellSrcExts HUnit
    languageEcmascript mtl optparseApplicative prettyShow safe
    sourcemap split syb testFramework testFrameworkHunit
    testFrameworkTh text time uniplate unorderedContainers utf8String
    vector
  ];
  meta = {
    homepage = "http://fay-lang.org/";
    description = "A compiler for Fay, a Haskell subset that compiles to JavaScript";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
