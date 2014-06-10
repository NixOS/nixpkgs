{ cabal, doctest, lens, singletons }:

cabal.mkDerivation (self: {
  pname = "vinyl";
  version = "0.4.1";
  sha256 = "1x8kxb4z4nj7h6pbl0r37rr7k88ly64cn0bf7izyaqjrsf0kxdci";
  testDepends = [ doctest lens singletons ];
  meta = {
    description = "Extensible Records";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
