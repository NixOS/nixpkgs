{ cabal, Cabal, constraints, filepath, mtl, tasty, tastyGolden
, thDesugar
}:

cabal.mkDerivation (self: {
  pname = "singletons";
  version = "0.10.0";
  sha256 = "14vnkw9ihrs3xg3lhb3wkyfz59lsaz4c3iqh3hqy7x9gmifgggwr";
  buildDepends = [ mtl thDesugar ];
  testDepends = [ Cabal constraints filepath tasty tastyGolden ];
  noHaddock = true;
  meta = {
    homepage = "http://www.cis.upenn.edu/~eir/packages/singletons";
    description = "A framework for generating singleton types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
