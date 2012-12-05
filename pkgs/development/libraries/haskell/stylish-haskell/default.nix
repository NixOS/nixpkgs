{ cabal, aeson, cmdargs, filepath, haskellSrcExts, mtl, strict, syb
, yaml
}:

cabal.mkDerivation (self: {
  pname = "stylish-haskell";
  version = "0.5.5.0";
  sha256 = "0hwpy779h4y4vrapfxfybjd5grkmasrvxm6rdfw415glqq37b03j";
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
