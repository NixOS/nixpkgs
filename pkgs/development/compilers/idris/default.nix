{ cabal, binary, Cabal, filepath, happy, haskeline, mtl, parsec
, transformers
}:

cabal.mkDerivation (self: {
  pname = "idris";
  version = "0.9.3";
  sha256 = "1g8mb5g4w6zgcfx2g7l5ksr0lsjfghznxgh684yzlg8pfzah0hqh";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    binary Cabal filepath haskeline mtl parsec transformers
  ];
  buildTools = [ happy ];
  meta = {
    homepage = "http://www.idris-lang.org/";
    description = "Functional Programming Language with Dependent Types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
