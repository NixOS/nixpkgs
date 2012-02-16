{ cabal }:

cabal.mkDerivation (self: {
  pname = "failure";
  version = "0.1.2";
  sha256 = "14pwj0zb5kk2wadpddanxv3kr0hzklxhzbprmkh40yn1dbwgdas4";
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Failure";
    description = "A simple type class for success/failure computations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
