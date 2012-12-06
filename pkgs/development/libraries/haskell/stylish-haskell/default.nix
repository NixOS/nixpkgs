{ cabal, aeson, cmdargs, filepath, haskellSrcExts, mtl, strict, syb
, yaml
}:

cabal.mkDerivation (self: {
  pname = "stylish-haskell";
  version = "0.5.5.1";
  sha256 = "0zkxvyj3h21ypzvwdkbpcf5gp4s5rdgiw5ciy62k99h6ch1kcwcr";
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
