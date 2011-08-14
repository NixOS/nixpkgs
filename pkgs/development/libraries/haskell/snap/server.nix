{ cabal, MonadCatchIOTransformers, PSQueue, attoparsec
, attoparsecEnumerator, binary, blazeBuilder
, blazeBuilderEnumerator, bytestringNums, caseInsensitive
, directoryTree, enumerator, mtl, murmurHash, network, snapCore
, text, time, transformers, unixCompat, vector, vectorAlgorithms
}:

cabal.mkDerivation (self: {
  pname = "snap-server";
  version = "0.5.3.1";
  sha256 = "0rbfklgngrpp2aggkmyamfxn9hpnz3bsxd58lw0fi4ls76bagxvz";
  buildDepends = [
    MonadCatchIOTransformers PSQueue attoparsec attoparsecEnumerator
    binary blazeBuilder blazeBuilderEnumerator bytestringNums
    caseInsensitive directoryTree enumerator mtl murmurHash network
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
