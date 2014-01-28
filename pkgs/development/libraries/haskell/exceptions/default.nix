{ cabal, mtl, QuickCheck, testFramework, testFrameworkQuickcheck2
, transformers
}:

cabal.mkDerivation (self: {
  pname = "exceptions";
  version = "0.3.3";
  sha256 = "1gng8zvsljm6xrb5gy501f1dl47z171wkic8bsivhn4rgp9lby9l";
  buildDepends = [ mtl transformers ];
  testDepends = [
    mtl QuickCheck testFramework testFrameworkQuickcheck2 transformers
  ];
  meta = {
    homepage = "http://github.com/ekmett/exceptions/";
    description = "Extensible optionally-pure exceptions";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
