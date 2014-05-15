{ cabal, aeson, attoparsec, dataDefault, filepath, ghcPaths, groom
, haskellNames, haskellPackages, haskellSrcExts, languageEcmascript
, mtl, optparseApplicative, safe, sourcemap, split, spoon, syb
, tasty, tastyHunit, tastyTh, text, transformers, uniplate
, unorderedContainers, utf8String, vector
}:

cabal.mkDerivation (self: {
  pname = "fay";
  version = "0.20.0.3";
  sha256 = "1vs4brndk091mp7lm057my4ghlpv3563qg5blrs5zqcmnwnm75x5";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson attoparsec dataDefault filepath ghcPaths groom haskellNames
    haskellPackages haskellSrcExts languageEcmascript mtl
    optparseApplicative safe sourcemap split spoon syb tasty tastyHunit
    tastyTh text transformers uniplate unorderedContainers utf8String
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
