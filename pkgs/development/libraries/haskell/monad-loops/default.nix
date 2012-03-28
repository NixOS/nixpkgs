{ cabal, stm }:

cabal.mkDerivation (self: {
  pname = "monad-loops";
  version = "0.3.2.0";
  sha256 = "0si8vz1r13lwliya161kwgrb5dpj01j74b6gbjyv78d5fd4hn7n2";
  buildDepends = [ stm ];
  meta = {
    homepage = "https://github.com/mokus0/monad-loops";
    description = "Monadic loops";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
