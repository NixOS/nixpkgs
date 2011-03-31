{cabal, attoparsec, attoparsecEnumerator, binary, blazeBuilder, blazeBuilderEnumerator
, bytestringNums, directoryTree, enumerator, MonadCatchIOTransformers, mtl, murmurHash
, network, PSQueue, snapCore, unixCompat, utf8String, vector, vectorAlgorithms, zlib}:

cabal.mkDerivation (self : {
  pname = "snap-server";
  version = "0.4.1";
  sha256 = "1xav58sk6f1capibkil9a834lxg7badcq3v8016azzzmvvhy9iq8";
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

