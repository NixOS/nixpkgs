{ cabal, Cabal, HaXml, mtl }:

cabal.mkDerivation (self: {
  pname = "TableAlgebra";
  version = "0.7.1";
  sha256 = "1jqkjnyznklyiy2shm4c9gix267war1hmsjncdmailhca41fs4bz";
  buildDepends = [ Cabal HaXml mtl ];
  meta = {
    description = "Ferry Table Algebra";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
