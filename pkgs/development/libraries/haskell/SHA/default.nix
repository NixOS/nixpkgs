{ cabal, binary }:

cabal.mkDerivation (self: {
  pname = "SHA";
  version = "1.5.0.0";
  sha256 = "12sz1dblmpiy8bg45fwndp1g9gf7494vqqbvbd1hwr5qzyfwyqck";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ binary ];
  meta = {
    description = "Implementations of the SHA suite of message digest functions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
