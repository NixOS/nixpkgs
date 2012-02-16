{ cabal, Cabal }:

cabal.mkDerivation (self: {
  pname = "syb";
  version = "0.3";
  sha256 = "1gnqw76zy7xvlabhbyk8hml88hpz2igf7b3mz2ic091f77qkkch7";
  buildDepends = [ Cabal ];
  meta = {
    homepage = "http://www.cs.uu.nl/wiki/GenericProgramming/SYB";
    description = "Scrap Your Boilerplate";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
