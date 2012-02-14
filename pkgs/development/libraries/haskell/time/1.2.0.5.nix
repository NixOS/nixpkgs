{ cabal, Cabal }:

cabal.mkDerivation (self: {
  pname = "time";
  version = "1.2.0.5";
  sha256 = "0y4plv9qvpmzzzb5855zngm6lmd38m0vr2mzwm94xhz2xsqhdh2z";
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
