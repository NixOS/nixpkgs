{ cabal, Cabal }:

cabal.mkDerivation (self: {
  pname = "extensible-exceptions";
  version = "0.1.1.2";
  sha256 = "0rsdvb7k8mp88s1jjmna17qa6363vbjgvlkpncmn8516dnxhypg3";
  buildDepends = [ Cabal ];
  meta = {
    description = "Extensible exceptions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
