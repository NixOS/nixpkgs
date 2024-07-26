{ mkDerivation, aeson, aeson-pretty, base, base-compat-batteries
, bytestring, Cabal, cabal-doctest, containers, cookie, doctest
, generics-sop, Glob, hashable, hspec, hspec-discover, http-media
, HUnit, insert-ordered-containers, lens, lib, mtl, optics-core
, optics-th, QuickCheck, quickcheck-instances, scientific
, template-haskell, text, time, transformers, unordered-containers
, utf8-string, uuid-types, vector
}:
mkDerivation {
  pname = "openapi3";
  version = "3.2.4";
  sha256 = "dbcb90464b4712a03c37fa3fcaca3a6784ace2794d85730a8a8c5d9b3ea14ba0";
  revision = "1";
  editedCabalFile = "08ikd506fxz3pllg5w8lx9yn9qfqlx9il9xwzz7s17yxn5k3xmnk";
  isLibrary = true;
  isExecutable = true;
  setupHaskellDepends = [ base Cabal cabal-doctest ];
  libraryHaskellDepends = [
    aeson aeson-pretty base base-compat-batteries bytestring containers
    cookie generics-sop hashable http-media insert-ordered-containers
    lens mtl optics-core optics-th QuickCheck scientific
    template-haskell text time transformers unordered-containers
    uuid-types vector
  ];
  executableHaskellDepends = [ aeson base lens text ];
  testHaskellDepends = [
    aeson base base-compat-batteries bytestring containers doctest Glob
    hashable hspec HUnit insert-ordered-containers lens mtl QuickCheck
    quickcheck-instances template-haskell text time
    unordered-containers utf8-string vector
  ];
  testToolDepends = [ hspec-discover ];
  homepage = "https://github.com/biocad/openapi3";
  description = "OpenAPI 3.0 data model";
  license = lib.licenses.bsd3;
  mainProgram = "example";
}
