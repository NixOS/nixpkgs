{ cabal, attoparsec, attoparsecEnumerator, binary, blazeBuilder
, blazeBuilderEnumerator, bytestringNums, caseInsensitive
, directoryTree, enumerator, MonadCatchIOTransformers, mtl
, murmurHash, network, PSQueue, snapCore, text, time, transformers
, unixCompat, vector, vectorAlgorithms
}:

cabal.mkDerivation (self: {
  pname = "snap-server";
  version = "0.6.0";
  sha256 = "1a9hi252h8k6s0hf6nnla6kf3ad899q7q3q78v1ifdpr5k9nrmq2";
  buildDepends = [
    attoparsec attoparsecEnumerator binary blazeBuilder
    blazeBuilderEnumerator bytestringNums caseInsensitive directoryTree
    enumerator MonadCatchIOTransformers mtl murmurHash network PSQueue
    snapCore text time transformers unixCompat vector vectorAlgorithms
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
