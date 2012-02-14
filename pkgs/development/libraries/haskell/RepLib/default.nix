{ cabal, Cabal, mtl, typeEquality }:

cabal.mkDerivation (self: {
  pname = "RepLib";
  version = "0.5.1";
  sha256 = "1c6zqi87lmmmiz8amsvhw6wkhg90rhh6yl5vh0a9ism3apwh1i7r";
  buildDepends = [ Cabal mtl typeEquality ];
  noHaddock = true;
  meta = {
    homepage = "http://code.google.com/p/replib/";
    description = "Generic programming library with representation types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
