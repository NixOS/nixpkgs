{ cabal, Cabal }:

cabal.mkDerivation (self: {
  pname = "time";
  version = "1.1.3";
  sha256 = "46d32400bc0099ccef1fb670684c00a31055725403ea15c7a39278ff7dccc65b";
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
