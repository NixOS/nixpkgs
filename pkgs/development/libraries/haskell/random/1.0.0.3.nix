{cabal, time}:

cabal.mkDerivation (self : {
  pname = "random";
  version = "1.0.0.3"; # future platform?
  sha256 = "0k2735vrx0id2dxzk7lkm22w07p7gy86zffygk60jxgh9rvignf6";
  propagatedBuildInputs = [time];
  meta = {
    description = "random number library";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
