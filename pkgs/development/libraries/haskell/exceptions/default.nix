{ cabal, mtl, QuickCheck, testFramework, testFrameworkQuickcheck2
, transformers
}:

cabal.mkDerivation (self: {
  pname = "exceptions";
  version = "0.3.2";
  sha256 = "0c1d78wm8is9kyv26drbx3f1sq2bfcq5m6wfw2qzwgalb3z2kxlw";
  buildDepends = [ mtl transformers ];
  testDepends = [
    mtl QuickCheck testFramework testFrameworkQuickcheck2 transformers
  ];
  doCheck = false;
  meta = {
    homepage = "http://github.com/ekmett/exceptions/";
    description = "Extensible optionally-pure exceptions";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
