{cabal, attoparsec, attoparsecEnumerator, binary, blazeBuilder, blazeBuilderEnumerator
, bytestringNums, directoryTree, enumerator, MonadCatchIOTransformers, mtl, murmurHash
, network, PSQueue, snapCore, unixCompat, utf8String, vector, vectorAlgorithms, zlib}:

cabal.mkDerivation (self : {
  pname = "snap-server";
  version = "0.5.1.4";
  sha256 = "17b95db48as418whcvbxzyvql16z1c706n0s4jryyqr6kvgpsvzp";
  propagatedBuildInputs =
    [ attoparsec attoparsecEnumerator binary blazeBuilder blazeBuilderEnumerator
     bytestringNums directoryTree enumerator MonadCatchIOTransformers mtl murmurHash
     network PSQueue snapCore unixCompat utf8String vector vectorAlgorithms zlib
    ];
  meta = {
    description = "Snap: A Haskell Web Framework (Server)";
    license = "BSD3";
  };
})

