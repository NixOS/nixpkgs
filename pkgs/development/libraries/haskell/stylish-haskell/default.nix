{ cabal, aeson, cmdargs, filepath, haskellSrcExts, mtl, strict, syb
, yaml
}:

cabal.mkDerivation (self: {
  pname = "stylish-haskell";
  version = "0.4.0.0";
  sha256 = "1d5a7a5f1lbyf7if0sb9vhmnbi5ry28wakhsgh75hvgzd999vbhx";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    aeson cmdargs filepath haskellSrcExts mtl strict syb yaml
  ];
  meta = {
    homepage = "https://github.com/jaspervdj/stylish-haskell";
    description = "Haskell code prettifier";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
