{ cabal, aeson, attoparsec, dataDefault, filepath, ghcPaths, groom
, haskellNames, haskellPackages, haskellSrcExts, languageEcmascript
, mtl, optparseApplicative, safe, sourcemap, split, spoon, syb
, tasty, tastyHunit, tastyTh, text, time, transformers, uniplate
, unorderedContainers, utf8String, vector
}:

cabal.mkDerivation (self: {
  pname = "fay";
  version = "0.20.1.0";
  sha256 = "0b2nhf1qnlr5pa03dcy487ylb3aldrn6cj0hkjsa761pkb8mkw71";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson attoparsec dataDefault filepath ghcPaths groom haskellNames
    haskellPackages haskellSrcExts languageEcmascript mtl
    optparseApplicative safe sourcemap split spoon syb tasty tastyHunit
    tastyTh text time transformers uniplate unorderedContainers
    utf8String vector
  ];
  meta = {
    homepage = "http://fay-lang.org/";
    description = "A compiler for Fay, a Haskell subset that compiles to JavaScript";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
