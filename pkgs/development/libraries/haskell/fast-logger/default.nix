{ cabal, blazeBuilder, filepath, hspec, text }:

cabal.mkDerivation (self: {
  pname = "fast-logger";
  version = "2.0.0";
  sha256 = "0a2pmdj2q1mlpkwjszlb4gp6xk2bn8540cqhwjya55arx6rj9vs7";
  buildDepends = [ blazeBuilder filepath text ];
  testDepends = [ hspec ];
  meta = {
    description = "A fast logging system";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
