{ mkDerivation, array, base, base-compat, base-orphans, bifunctors
, bytestring, Cabal, cabal-doctest, call-stack, comonad, containers
, contravariant, criterion, deepseq, directory, distributive
, doctest, exceptions, filepath, free, generic-deriving, ghc-prim
, hashable, HUnit, kan-extensions, lib, mtl, nats, parallel
, profunctors, QuickCheck, reflection, semigroupoids, semigroups
, simple-reflect, tagged, template-haskell, test-framework
, test-framework-hunit, test-framework-quickcheck2, text
, th-abstraction, transformers, transformers-compat
, unordered-containers, vector
}:
mkDerivation {
  pname = "lens";
  version = "4.19.2";
  sha256 = "0fy2vr5r11cc6ana8m2swqgs3zals4kims55vd6119bi76p5iy2j";
  revision = "6";
  editedCabalFile = "1k08my9rh1il3ibiyhljxkgndfgk143pn5a6nyzjnckw3la09myl";
  setupHaskellDepends = [ base Cabal cabal-doctest filepath ];
  libraryHaskellDepends = [
    array base base-orphans bifunctors bytestring call-stack comonad
    containers contravariant distributive exceptions filepath free
    ghc-prim hashable kan-extensions mtl parallel profunctors
    reflection semigroupoids tagged template-haskell text
    th-abstraction transformers transformers-compat
    unordered-containers vector
  ];
  testHaskellDepends = [
    base bytestring containers deepseq directory doctest filepath
    generic-deriving HUnit mtl nats parallel QuickCheck semigroups
    simple-reflect test-framework test-framework-hunit
    test-framework-quickcheck2 text transformers unordered-containers
    vector
  ];
  benchmarkHaskellDepends = [
    base base-compat bytestring comonad containers criterion deepseq
    generic-deriving transformers unordered-containers vector
  ];
  homepage = "http://github.com/ekmett/lens/";
  description = "Lenses, Folds and Traversals";
  license = lib.licenses.bsd2;
}
