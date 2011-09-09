{ cabal }:

cabal.mkDerivation (self: {
  pname = "generic-deriving";
  version = "1.0.2";
  sha256 = "0qj4ql44f87rgg5l512mh863c1zjfklw1w5k8x4nyw37s7qx9hvq";
  meta = {
    description = "Generic programming library for generalized deriving.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
