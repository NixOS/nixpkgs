{ cabal }:

cabal.mkDerivation (self: {
  pname = "entropy";
  version = "0.2.1";
  sha256 = "1qp8hvdzfgg2wk7d431qycwbn2zpzlplc1c7dbhimj1had5jscrs";
  meta = {
    homepage = "http://trac.haskell.org/crypto-api/wiki";
    description = "A platform independent entropy source";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
