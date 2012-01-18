{ cabal, binary, epic, happy, haskeline, mtl, parsec, transformers
}:

cabal.mkDerivation (self: {
  pname = "idris";
  version = "0.9.0";
  sha256 = "03zbdcl3v90zv0ibzq9fa8z2qrrdsilh5m509mczwrcmlzbzsmrl";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ binary epic haskeline mtl parsec transformers ];
  buildTools = [ happy ];
  noHaddock = true;
  meta = {
    homepage = "http://www.idris-lang.org/";
    description = "Dependently Typed Functional Programming Language";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
