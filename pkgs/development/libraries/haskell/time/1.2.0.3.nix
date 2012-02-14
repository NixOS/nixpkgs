{ cabal, Cabal }:

cabal.mkDerivation (self: {
  pname = "time";
  version = "1.2.0.3";
  sha256 = "acb1e3cf2b98a73632d35b0665808b05df6c03fcefd62796fe291f5b2ef4348e";
  buildDepends = [ Cabal ];
  meta = {
    homepage = "http://semantic.org/TimeLib/";
    description = "A time library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
