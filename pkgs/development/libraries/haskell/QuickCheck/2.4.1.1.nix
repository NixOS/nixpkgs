{ cabal, extensibleExceptions, random }:

cabal.mkDerivation (self: {
  pname = "QuickCheck";
  version = "2.4.1.1";
  sha256 = "06vrn0j26ai2jfl32yd3kx8by4pimcinjf23b0dyc35z2gb139wj";
  buildDepends = [ extensibleExceptions random ];
  meta = {
    homepage = "http://code.haskell.org/QuickCheck";
    description = "Automatic testing of Haskell programs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
