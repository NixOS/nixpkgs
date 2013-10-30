{ cabal }:

cabal.mkDerivation (self: {
  pname = "intervals";
  version = "0.3";
  sha256 = "1k8dhhwa6y5hrkm9np9x953bdn3pgk5c2lkl3zgrrmrwmd075422";
  meta = {
    homepage = "http://github.com/ekmett/intervals";
    description = "Interval Arithmetic";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
