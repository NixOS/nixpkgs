{ cabal, attoparsec, attoparsecEnumerator, binary, blazeBuilder
, blazeBuilderEnumerator, bytestringNums, caseInsensitive
, directoryTree, enumerator, filepath, MonadCatchIOTransformers
, mtl, murmurHash, network, PSQueue, snapCore, text, time
, transformers, unixCompat, vector, vectorAlgorithms
}:

cabal.mkDerivation (self: {
  pname = "snap-server";
  version = "0.8.0.1";
  sha256 = "1648p0m4n4ha4976gw891z112rzxd9q4s7n4x3v0z3qb10aynxjb";
  buildDepends = [
    attoparsec attoparsecEnumerator binary blazeBuilder
    blazeBuilderEnumerator bytestringNums caseInsensitive directoryTree
    enumerator filepath MonadCatchIOTransformers mtl murmurHash network
    PSQueue snapCore text time transformers unixCompat vector
    vectorAlgorithms
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
