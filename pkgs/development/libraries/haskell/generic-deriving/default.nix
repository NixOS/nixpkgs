{ cabal }:

cabal.mkDerivation (self: {
  pname = "generic-deriving";
  version = "1.0.3";
  sha256 = "0g5sw4m9qdr1l47zq15l6jk9ksz1nazssdxz7lrdqx6ib3xbrz6y";
  meta = {
    description = "Generic programming library for generalized deriving";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
