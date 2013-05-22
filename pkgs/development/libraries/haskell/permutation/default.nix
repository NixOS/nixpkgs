{ cabal }:

cabal.mkDerivation (self: {
  pname = "permutation";
  version = "0.4.1";
  sha256 = "0fgw4ivs8sa18fyphwr3mzp2v7ha2nz2yf3a7jmz9ymqdf2xws97";
  doCheck = false;
  meta = {
    homepage = "http://stat.stanford.edu/~patperry/code/permutation";
    description = "A library for permutations and combinations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
