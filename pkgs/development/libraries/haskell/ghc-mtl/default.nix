{cabal, mtl, MonadCatchIOMtl} :

cabal.mkDerivation (self : {
  pname = "ghc-mtl";
  version = "1.0.1.0";
  sha256 = "5284e0ecf99511e6263503412faf6fa809dc577c009fde63203d46405eb1b191";
  propagatedBuildInputs = [mtl MonadCatchIOMtl];
  meta = {
    description = "An mtl compatible version of the Ghc-Api monads and monad-transformers";
  };
})  

