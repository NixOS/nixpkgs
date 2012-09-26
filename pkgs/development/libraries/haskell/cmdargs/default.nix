{ cabal, filepath, transformers }:

cabal.mkDerivation (self: {
  pname = "cmdargs";
  version = "0.10";
  sha256 = "1xx4cks3hr2ldb0hd5hnc53dpns2zm4gc1dw25gs1vc977kga3hz";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ filepath transformers ];
  meta = {
    homepage = "http://community.haskell.org/~ndm/cmdargs/";
    description = "Command line argument processing";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
