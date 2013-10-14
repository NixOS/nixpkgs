{ cabal, numericExtras }:

cabal.mkDerivation (self: {
  pname = "intervals";
  version = "0.2.2.1";
  sha256 = "0kbsms3742ppmzbmrfp94aq4wvwrayx5ppsyk7pd1mj7y47aay0f";
  buildDepends = [ numericExtras ];
  meta = {
    homepage = "http://github.com/ekmett/intervals";
    description = "Interval Arithmetic";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
