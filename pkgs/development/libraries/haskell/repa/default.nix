{cabal, QuickCheck, vector}:

cabal.mkDerivation (self : {
  pname = "repa";
  version = "2.0.0.4";
  sha256 = "11cjh4bdwb1kwb6ikig4i6vr3kqs840wdpl22biws16lg74mfxxn";
  propagatedBuildInputs = [QuickCheck vector];
  meta = {
    description = "High performance, regular, shape polymorphic parallel arrays";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

