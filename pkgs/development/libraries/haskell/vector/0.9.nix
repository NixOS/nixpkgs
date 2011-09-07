{ cabal, primitive }:

cabal.mkDerivation (self: {
  pname = "vector";
  version = "0.9";
  sha256 = "0m8sfp924sw5dwr9a63jgsbj98qm9nyy903842x6ii4ljb1cpynz";
  buildDepends = [ primitive ];
  meta = {
    homepage = "http://code.haskell.org/vector";
    description = "Efficient Arrays";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
