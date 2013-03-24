{ cabal, sybWithClass, text }:

cabal.mkDerivation (self: {
  pname = "syb-with-class-instances-text";
  version = "0.0.1";
  sha256 = "0e0aa90c02cbe76380274830be51e04cb3cc13d5ea5761ba5540779bd0c4d76e";
  buildDepends = [ sybWithClass text ];
  meta = {
    description = "Scrap Your Boilerplate With Class Text instance";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
