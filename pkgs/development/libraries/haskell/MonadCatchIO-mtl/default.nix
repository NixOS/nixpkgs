{cabal, mtl, extensibleExceptions} :

cabal.mkDerivation (self : {
  pname = "MonadCatchIO-mtl";
  version = "0.3.0.1";
  sha256 = "56113319439a10e338b2e3169e1df575024fbaf97827511f4856e46efbac9a07";
  propagatedBuildInputs = [mtl extensibleExceptions];
  meta = {
    description = "Monad-transformer version of the Control.Exception module";
  };
})  

