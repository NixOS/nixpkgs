{cabal, dataDefault}:

cabal.mkDerivation (self : {
  pname = "tagged";
  version = "0.2";
  sha256 = "0hwc0hhq5pzihx6danxvgs4k1z0nqcrwf3ji0w2i1gx3298cwrz5";
  propagatedBuildInputs = [dataDefault];
  meta = {
    description = "Provides newtype wrappers for phantom types to avoid unsafely passing dummy arguments";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

