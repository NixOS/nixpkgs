{ mkDerivation, alex, array, base, blaze-builder, bytestring, Cabal
, containers, happy, hspec, lib, mtl, QuickCheck, text, utf8-light
, utf8-string
}:
mkDerivation {
  pname = "language-javascript";
  version = "0.7.0.0";
  sha256 = "d39e80675c40529574ee93c2bdec1a86497da7a53f39c7d174c30b27e7c57795";
  libraryHaskellDepends = [
    array base blaze-builder bytestring containers mtl text utf8-string
  ];
  libraryToolDepends = [ alex happy ];
  testHaskellDepends = [
    array base blaze-builder bytestring Cabal containers hspec mtl
    QuickCheck utf8-light utf8-string
  ];
  homepage = "https://github.com/erikd/language-javascript";
  description = "Parser for JavaScript";
  license = lib.licenses.bsd3;
}
