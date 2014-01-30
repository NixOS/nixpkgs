{ cabal, aeson, attoparsec, Cabal, cpphs, dataDefault, filepath
, ghcPaths, haskellNames, haskellPackages, haskellSrcExts, HUnit
, languageEcmascript, mtl, optparseApplicative, prettyShow, safe
, scientific, sourcemap, split, syb, testFramework
, testFrameworkHunit, testFrameworkTh, text, time, uniplate
, unorderedContainers, utf8String, vector
}:

cabal.mkDerivation (self: {
  pname = "fay";
  version = "0.19.0.1";
  sha256 = "036z4wz7vziaczhx1ysbm7d2302n2sb6l1z48py8spai5awkbvh0";
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
