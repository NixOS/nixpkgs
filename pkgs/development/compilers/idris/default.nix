{ cabal, binary, Cabal, epic, filepath, happy, haskeline, mtl
, parsec, transformers
}:

cabal.mkDerivation (self: {
  pname = "idris";
  version = "0.9.2.1";
  sha256 = "16jbmyza57066s3wmkvgwn11kqn0nzkjrrvsinh9xd69a79h2iiy";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    binary Cabal epic filepath haskeline mtl parsec transformers
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
