{ cabal, attoparsec, attoparsecEnumerator, binary, blazeBuilder
, blazeBuilderEnumerator, bytestringNums, Cabal, caseInsensitive
, directoryTree, enumerator, filepath, MonadCatchIOTransformers
, mtl, murmurHash, network, PSQueue, snapCore, text, time
, transformers, unixCompat, vector, vectorAlgorithms
}:

cabal.mkDerivation (self: {
  pname = "snap-server";
  version = "0.7.0.1";
  sha256 = "149jgd9mcndw9sc051020y7yiai1fipjnqk4s3sbw4lmaysap673";
  buildDepends = [
    attoparsec attoparsecEnumerator binary blazeBuilder
    blazeBuilderEnumerator bytestringNums Cabal caseInsensitive
    directoryTree enumerator filepath MonadCatchIOTransformers mtl
    murmurHash network PSQueue snapCore text time transformers
    unixCompat vector vectorAlgorithms
  ];
  meta = {
    homepage = "http://snapframework.com/";
    description = "A fast, iteratee-based, epoll-enabled web server for the Snap Framework";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
