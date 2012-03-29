{ cabal, filepath, haskellSrcExts, syb, transformers, uniplate }:

cabal.mkDerivation (self: {
  pname = "derive";
  version = "2.5.7";
  sha256 = "1a6nz0a7axgdghljcb87h4bhisjfsnpxpdbqlrxymw4zqislg9p3";
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
