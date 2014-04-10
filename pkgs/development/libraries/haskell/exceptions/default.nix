{ cabal, mtl, QuickCheck, testFramework, testFrameworkQuickcheck2
, transformers
}:

cabal.mkDerivation (self: {
  pname = "exceptions";
  version = "0.5";
  sha256 = "0l9gpifp23j6hvyq8p48rxsnv9adqbf7z096dzvd8v5xqqybgyxi";
  buildDepends = [ mtl transformers ];
  testDepends = [
    mtl QuickCheck testFramework testFrameworkQuickcheck2 transformers
  ];
  meta = {
    homepage = "http://github.com/ekmett/exceptions/";
    description = "Extensible optionally-pure exceptions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
