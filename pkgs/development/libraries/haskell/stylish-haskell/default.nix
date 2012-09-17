{ cabal, aeson, cmdargs, filepath, haskellSrcExts, mtl, strict, syb
, yaml
}:

cabal.mkDerivation (self: {
  pname = "stylish-haskell";
  version = "0.5.0.2";
  sha256 = "0am63hw24c1yja1sb2xsbi1bcyfxb1qsypszkpaylvks797czmc7";
  isLibrary = true;
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
