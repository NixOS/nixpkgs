{ cabal, aeson, attoparsec, Cabal, cpphs, dataDefault, filepath
, ghcPaths, haskellNames, haskellPackages, haskellSrcExts, HUnit
, languageEcmascript, mtl, optparseApplicative, prettyShow, safe
, scientific, sourcemap, split, syb, testFramework
, testFrameworkHunit, testFrameworkTh, text, time, uniplate
, unorderedContainers, utf8String, vector
}:

cabal.mkDerivation (self: {
  pname = "fay";
  version = "0.19.2";
  sha256 = "08lq2x87gsf5szdj613k9h3qxzpb99hjhxnq3vggs2kf0ijp6xmh";
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
