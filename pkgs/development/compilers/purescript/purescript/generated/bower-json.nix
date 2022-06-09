{ mkDerivation, aeson, aeson-better-errors, base, bytestring
, deepseq, ghc-prim, lib, mtl, scientific, tasty, tasty-hunit, text
, transformers, unordered-containers, vector
}:
mkDerivation {
  pname = "bower-json";
  version = "1.0.0.1";
  sha256 = "7aa954e2b1bf79307db710c158108bd9ddb45b333ca96072cdbfaf96c77b7e73";
  libraryHaskellDepends = [
    aeson aeson-better-errors base bytestring deepseq ghc-prim mtl
    scientific text transformers unordered-containers vector
  ];
  testHaskellDepends = [
    aeson base bytestring tasty tasty-hunit text unordered-containers
  ];
  homepage = "https://github.com/hdgarrood/bower-json";
  description = "Read bower.json from Haskell";
  license = lib.licenses.mit;
}
