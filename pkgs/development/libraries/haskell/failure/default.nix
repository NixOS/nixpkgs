{ cabal }:

cabal.mkDerivation (self: {
  pname = "failure";
  version = "0.1.0.1";
  sha256 = "15zkhnxkfsd3qf4wmcp6kcfip9ahb4s3ywnh14whmhicp9mkm3q0";
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Failure";
    description = "A simple type class for success/failure computations.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
