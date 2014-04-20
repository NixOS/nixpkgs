{ cabal, filepath, haskellSrcExts, syb, transformers, uniplate }:

cabal.mkDerivation (self: {
  pname = "derive";
  version = "2.5.14";
  sha256 = "1fihcd8l4z8d6rad8h39pg5gdb75h895c2xld9574fwp3bm0zl0c";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    filepath haskellSrcExts syb transformers uniplate
  ];
  meta = {
    homepage = "http://community.haskell.org/~ndm/derive/";
    description = "A program and library to derive instances for data types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
