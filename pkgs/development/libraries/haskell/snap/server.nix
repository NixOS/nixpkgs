{ cabal, attoparsec, attoparsecEnumerator, binary, blazeBuilder
, blazeBuilderEnumerator, bytestringNums, caseInsensitive
, directoryTree, enumerator, filepath, MonadCatchIOTransformers
, mtl, murmurHash, network, PSQueue, snapCore, text, time
, transformers, unixCompat, vector, vectorAlgorithms
}:

cabal.mkDerivation (self: {
  pname = "snap-server";
  version = "0.8.1.1";
  sha256 = "0k47z9fhc64bnv86ixaxvndwc7hk28ny3mf5ny9d5jmp77a3ws46";
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
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
