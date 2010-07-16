{cabal, extensibleExceptions, filepath, ghcMtl,
 ghcPaths, haskellSrc, MonadCatchIOMtl, mtl, utf8String} :

cabal.mkDerivation (self : {
  pname = "hint";
  version = "0.3.2.3";
  sha256 = "1cc01037cfd32eb1a299ce625487411a97ce70178778d7bbd1d5fcef7d3d40c4";
  propagatedBuildInputs = [
    extensibleExceptions filepath ghcMtl ghcPaths haskellSrc
    MonadCatchIOMtl mtl utf8String
  ];
  meta = {
    description = "An mtl compatible version of the Ghc-Api monads and monad-transformers";
  };
})  

