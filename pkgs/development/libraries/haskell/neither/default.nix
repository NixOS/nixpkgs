{ cabal, failure, transformers }:

cabal.mkDerivation (self: {
  pname = "neither";
  version = "0.3.1";
  sha256 = "1n00v2xs2ghm273barc3bbi67wgpvyihhgl1ij7qczyp9fhqlyfk";
  buildDepends = [ failure transformers ];
  meta = {
    homepage = "http://github.com/snoyberg/neither";
    description = "Provide versions of Either with good monad and applicative instances. (deprecated)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
