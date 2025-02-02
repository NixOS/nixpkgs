{ mkDerivation, aeson, avh4-lib, base, bimap, binary, bytestring
, containers, elm-format-markdown, elm-format-test-lib, fetchgit
, hspec, lib, mtl, optparse-applicative, relude, split, tasty
, tasty-discover, tasty-hspec, tasty-hunit, text
}:
mkDerivation {
  pname = "elm-format-lib";
  version = "0.0.0.1";
  src = fetchgit {
    url = "https://github.com/avh4/elm-format";
    sha256 = "04l1bn4w8q3ifd6mc4mfrqxfbihmqnpfjdn6gr0x2jqcasjbk0bi";
    rev = "b5cca4c26b473dab06e5d73b98148637e4770d45";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/elm-format-lib; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson avh4-lib base bimap binary bytestring containers
    elm-format-markdown mtl optparse-applicative relude text
  ];
  testHaskellDepends = [
    aeson avh4-lib base bimap binary bytestring containers
    elm-format-markdown elm-format-test-lib hspec mtl
    optparse-applicative relude split tasty tasty-hspec tasty-hunit
    text
  ];
  testToolDepends = [ tasty-discover ];
  description = "Common code used by elm-format and elm-refactor";
  license = lib.licenses.bsd3;
}
