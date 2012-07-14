{ cabal }:

cabal.mkDerivation (self: {
  pname = "largeword";
  version = "1.0.2";
  sha256 = "0ylbl9rffhqw9ahasn23n00h7v5yqmghmqkrq446zdr72bq23hk2";
  meta = {
    homepage = "http://trac.haskell.org/largeword/wiki";
    description = "Provides Word128, Word192 and Word256 and a way of producing other large words if required";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
