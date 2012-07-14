{ cabal, attoparsec, attoparsecEnumerator, binary, blazeBuilder
, blazeBuilderEnumerator, bytestringNums, caseInsensitive
, directoryTree, enumerator, filepath, MonadCatchIOTransformers
, mtl, murmurHash, network, snapCore, text, time, transformers
, unixCompat, vector, vectorAlgorithms
}:

cabal.mkDerivation (self: {
  pname = "snap-server";
  version = "0.9.0";
  sha256 = "12mjy1w6gsnw93bcpsnxnw7kc2v73dfps7gk542iw73lldfhh3va";
  buildDepends = [
    attoparsec attoparsecEnumerator binary blazeBuilder
    blazeBuilderEnumerator bytestringNums caseInsensitive directoryTree
    enumerator filepath MonadCatchIOTransformers mtl murmurHash network
    snapCore text time transformers unixCompat vector vectorAlgorithms
  ];
  meta = {
    homepage = "http://snapframework.com/";
    description = "A fast, iteratee-based, epoll-enabled web server for the Snap Framework";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
