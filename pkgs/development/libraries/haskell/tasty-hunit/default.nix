{ cabal, HUnit, mtl, tasty }:

cabal.mkDerivation (self: {
  pname = "tasty-hunit";
  version = "0.2";
  sha256 = "1476ac3rsaag9rfgglzs65wqlkzm09xzdz47ksyj3a4c6ajba1kw";
  buildDepends = [ HUnit mtl tasty ];
  meta = {
    description = "HUnit support for the Tasty test framework";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
