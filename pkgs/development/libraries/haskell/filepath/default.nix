{ cabal, QuickCheck, random }:

cabal.mkDerivation (self: {
  pname = "filepath";
  version = "1.3.0.2";
  sha256 = "0wvvz6cs5fh4f04a87b9s7xrnzypmnzzkn149p6xk8xi7gcvcpy2";
  testDepends = [ QuickCheck random ];
  meta = {
    homepage = "http://www-users.cs.york.ac.uk/~ndm/filepath/";
    description = "Library for manipulating FilePaths in a cross platform way";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
