{ cabal, binary, Cabal, filepath, happy, haskeline, mtl, parsec
, transformers
}:

cabal.mkDerivation (self: {
  pname = "idris";
  version = "0.9.3.1";
  sha256 = "1dqb7gd5jn5f062hfwrirrfxv6ac1f6khkfax912j01mg147hv9a";
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
