{ cabal, HUnit, stm, testFramework, testFrameworkHunit }:

cabal.mkDerivation (self: {
  pname = "async";
  version = "2.0.1.4";
  sha256 = "1hi40bjwpl65mz7zj0sgh16bp9dwafbm5ysi2q8fzwwq5l0zxpa1";
  buildDepends = [ stm ];
  testDepends = [ HUnit testFramework testFrameworkHunit ];
  meta = {
    homepage = "https://github.com/simonmar/async";
    description = "Run IO operations asynchronously and wait for their results";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
