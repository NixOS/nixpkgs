{ cabal, time }:

cabal.mkDerivation (self: {
  pname = "random";
  version = "1.0.0.3";
  sha256 = "0k2735vrx0id2dxzk7lkm22w07p7gy86zffygk60jxgh9rvignf6";
  buildDepends = [ time ];
  meta = {
    description = "random number library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
