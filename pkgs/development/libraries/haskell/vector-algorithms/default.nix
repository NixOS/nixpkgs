{ cabal, mtl, mwcRandom, primitive, QuickCheck, vector }:

cabal.mkDerivation (self: {
  pname = "vector-algorithms";
  version = "0.6.0.1";
  sha256 = "0dkiz0c5dmc3a15zz5pxv4rz4n0bw5irb5a148gccfrg5c80vzc5";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ mtl mwcRandom primitive vector ];
  testDepends = [ QuickCheck vector ];
  meta = {
    homepage = "http://code.haskell.org/~dolio/";
    description = "Efficient algorithms for vector arrays";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
