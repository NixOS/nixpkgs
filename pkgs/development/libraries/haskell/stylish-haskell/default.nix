{ cabal, aeson, cmdargs, filepath, haskellSrcExts, HUnit, mtl
, strict, syb, testFramework, testFrameworkHunit, yaml
}:

cabal.mkDerivation (self: {
  pname = "stylish-haskell";
  version = "0.5.6.0";
  sha256 = "1cy40b7csna3fwq0bm5mx9d09x52vj517mf38yn8ymd0afff67sb";
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
