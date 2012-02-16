{ cabal, Cabal }:

cabal.mkDerivation (self: {
  pname = "stm";
  version = "2.1.1.2";
  sha256 = "68d550067ae180373142c51f3fa14bdf0a1516310aee9a37e28f9ac7cf3b8c6d";
  buildDepends = [ Cabal ];
  meta = {
    description = "Software Transactional Memory";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
