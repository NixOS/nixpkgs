{ cabal, Cabal }:

cabal.mkDerivation (self: {
  pname = "stm";
  version = "2.1.2.1";
  sha256 = "0d7d8babd2f07c726909030461e1f9b3aaf02dc809fd5e1c0509a67d23b784b8";
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
