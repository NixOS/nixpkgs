{ cabal, HUnit, mtl, tasty }:

cabal.mkDerivation (self: {
  pname = "tasty-hunit";
  version = "0.8.0.1";
  sha256 = "0a84j8yjqp9x59dy5nbb50vnscb7iimgc60s8vz1p5721gqi62r5";
  buildDepends = [ HUnit mtl tasty ];
  meta = {
    description = "HUnit support for the Tasty test framework";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
