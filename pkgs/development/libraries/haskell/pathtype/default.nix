{ cabal, QuickCheck, time }:

cabal.mkDerivation (self: {
  pname = "pathtype";
  version = "0.5.3";
  sha256 = "11plb7xw4j8vjziw1q0ymx33p6185cxd2hqrxw2hgsfzf2b9dvqg";
  buildDepends = [ QuickCheck time ];
  meta = {
    homepage = "http://code.haskell.org/pathtype";
    description = "Type-safe replacement for System.FilePath etc";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
