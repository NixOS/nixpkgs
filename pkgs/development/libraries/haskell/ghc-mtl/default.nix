{ cabal, exceptions, extensibleExceptions, mtl }:

cabal.mkDerivation (self: {
  pname = "ghc-mtl";
  version = "1.2.0.0";
  sha256 = "0fk3adc56nhi46nf2w5ybp3cd9l13qqbpd5nbhfhbqj3g73j8p5a";
  buildDepends = [ exceptions extensibleExceptions mtl ];
  meta = {
    homepage = "http://hub.darcs.net/jcpetruzza/ghc-mtl";
    description = "An mtl compatible version of the Ghc-Api monads and monad-transformers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
