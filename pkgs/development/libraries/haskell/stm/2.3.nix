{ cabal }:

cabal.mkDerivation (self: {
  pname = "stm";
  version = "2.3";
  sha256 = "1321l1qkmvnqdw73i21jnh2b8c1iw1mxjbp23hmqdvljjb9mlzsm";
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
