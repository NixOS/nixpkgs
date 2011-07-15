{cabal, attoparsec, attoparsecEnumerator, MonadCatchIOTransformers, blazeBuilder
, bytestringNums, caseInsensitive, dlist, mtl, unixCompat, vector, zlib}:

cabal.mkDerivation (self : {
  pname = "snap-core";
  version = "0.5.1.4";
  sha256 = "0fvff7hjyfwnii057vpg8m75qaipsklk6v6cbvms4p6wp14zqaj1";
  propagatedBuildInputs =
    [ attoparsec attoparsecEnumerator MonadCatchIOTransformers blazeBuilder
     bytestringNums caseInsensitive dlist mtl unixCompat vector zlib
    ];
  meta = {
    description = "Snap: A Haskell Web Framework (Core)";
    license = "BSD3";
  };
})

