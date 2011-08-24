{ cabal }:

cabal.mkDerivation (self: {
  pname = "stm";
  version = "2.2.0.1";
  sha256 = "1p0x414ffsd77mmlfz1cmwg2cbhinnbpxypxgvygg05js67msj8q";
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
