{cabal, attoparsec, attoparsecEnumerator, MonadCatchIOTransformers, blazeBuilder
, bytestringNums, dlist, mtl, unixCompat, vector, zlib}:

cabal.mkDerivation (self : {
  pname = "snap-core";
  version = "0.4.1";
  sha256 = "0cc6qh8rnfdhv6s4clnb4avbxkvvj4dibbdg0vjbf75iafxvsg9f";
  propagatedBuildInputs =
    [ attoparsec attoparsecEnumerator MonadCatchIOTransformers blazeBuilder
     bytestringNums dlist mtl unixCompat vector zlib
    ];
  meta = {
    description = "Snap: A Haskell Web Framework (Core)";
    license = "BSD3";
  };
})

