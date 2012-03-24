{ cabal, extensibleExceptions, mtl }:

cabal.mkDerivation (self: {
  pname = "MonadCatchIO-mtl";
  version = "0.3.0.4";
  sha256 = "0wzdrfplwa4v9miv88rg3jvf7l6gphc29lpdp5qjm5873y57jxm7";
  buildDepends = [ extensibleExceptions mtl ];
  meta = {
    homepage = "http://darcsden.com/jcpetruzza/MonadCatchIO-mtl";
    description = "Monad-transformer version of the Control.Exception module";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
