{ cabal, aeson, cmdargs, filepath, haskellSrcExts, mtl, strict, syb
, yaml
}:

cabal.mkDerivation (self: {
  pname = "stylish-haskell";
  version = "0.5.5.2";
  sha256 = "1whl8qdqyw2saic70kav8srg4f6bcn77mc86m0vk8i8n5mb3q4ny";
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
