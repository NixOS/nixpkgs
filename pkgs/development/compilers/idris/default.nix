{ cabal, binary, epic, happy, haskeline, mtl, parsec, transformers
}:

cabal.mkDerivation (self: {
  pname = "idris";
  version = "0.9.1";
  sha256 = "1yvw15750mqrvq1kd7bsk3ldq3s0z947c4f93pv7008gq5im4cvr";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ binary epic haskeline mtl parsec transformers ];
  buildTools = [ happy ];
  noHaddock = true;
  meta = {
    homepage = "http://www.idris-lang.org/";
    description = "Functional Programming Language with Dependent Types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
