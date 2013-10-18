{ cabal, HUnit, parsec, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "network";
  version = "2.4.2.0";
  sha256 = "1v6iwww8xym0sr2593ri0aa6gcs6n2975fi9gaz9n7rizbqm88qs";
  buildDepends = [ parsec ];
  testDepends = [
    HUnit testFramework testFrameworkHunit testFrameworkQuickcheck2
  ];
  meta = {
    homepage = "https://github.com/haskell/network";
    description = "Low-level networking interface";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
