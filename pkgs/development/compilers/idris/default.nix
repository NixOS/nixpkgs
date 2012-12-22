{ cabal, binary, Cabal, filepath, happy, haskeline, mtl, parsec
, transformers
}:

cabal.mkDerivation (self: {
  pname = "idris";
  version = "0.9.5.1";
  sha256 = "0cy27b2kq696lw354y55mpx1gv66jdax1xjph989kxp0rd1v1sw9";
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
