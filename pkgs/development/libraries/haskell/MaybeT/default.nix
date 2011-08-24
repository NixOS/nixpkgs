{ cabal, mtl }:

cabal.mkDerivation (self: {
  pname = "MaybeT";
  version = "0.1.2";
  sha256 = "995e61165122656807d84174e5c1516340fd7ddeba6571c20751352a8476b632";
  buildDepends = [ mtl ];
  meta = {
    description = "MaybeT monad transformer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
