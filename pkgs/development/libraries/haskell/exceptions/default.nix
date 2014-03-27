{ cabal, mtl, QuickCheck, testFramework, testFrameworkQuickcheck2
, transformers
}:

cabal.mkDerivation (self: {
  pname = "exceptions";
  version = "0.3.3.1";
  sha256 = "091frx3hmx7lq10z7f8q98pz0sa1lj23i7z4z98gh1980r525fah";
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
