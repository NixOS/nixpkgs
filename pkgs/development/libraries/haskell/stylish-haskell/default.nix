{ cabal, aeson, cmdargs, filepath, haskellSrcExts, HUnit, mtl
, strict, syb, testFramework, testFrameworkHunit, yaml
}:

cabal.mkDerivation (self: {
  pname = "stylish-haskell";
  version = "0.5.10.0";
  sha256 = "12sba4bbc1qzicvavlbf4wqj7xs2pk0z3ha70xsvldszhyav9zj9";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson cmdargs filepath haskellSrcExts mtl strict syb yaml
  ];
  testDepends = [
    aeson cmdargs filepath haskellSrcExts HUnit mtl syb testFramework
    testFrameworkHunit yaml
  ];
  meta = {
    homepage = "https://github.com/jaspervdj/stylish-haskell";
    description = "Haskell code prettifier";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
