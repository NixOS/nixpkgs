{ cabal, aeson, attoparsec, Cabal, cpphs, dataDefault, filepath
, ghcPaths, haskellNames, haskellPackages, haskellSrcExts, HUnit
, languageEcmascript, mtl, optparseApplicative, prettyShow, safe
, scientific, sourcemap, split, syb, testFramework
, testFrameworkHunit, testFrameworkTh, text, time, uniplate
, unorderedContainers, utf8String, vector
}:

cabal.mkDerivation (self: {
  pname = "fay";
  version = "0.19.1.1";
  sha256 = "1jjv7l4x1bxr4whhcn4vh4b3ac4wfnb6l322jmdj60nh9sj8dzpf";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson attoparsec Cabal cpphs dataDefault filepath ghcPaths
    haskellNames haskellPackages haskellSrcExts HUnit
    languageEcmascript mtl optparseApplicative prettyShow safe
    scientific sourcemap split syb testFramework testFrameworkHunit
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
