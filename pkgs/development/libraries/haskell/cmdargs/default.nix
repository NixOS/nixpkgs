{ cabal, filepath, transformers }:

cabal.mkDerivation (self: {
  pname = "cmdargs";
  version = "0.10.2";
  sha256 = "0vn7c569akyabij2bh9myyvnx08w67dwdvx5g5q36b3ixzp0lrg4";
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
