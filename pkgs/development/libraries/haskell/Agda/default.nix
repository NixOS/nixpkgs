{cabal, QuickCheck, binary, haskeline, haskellSrc, mtl, utf8String, xhtml, zlib,
 happy, alex}:

cabal.mkDerivation (self : {
  pname = "Agda";
  version = "2.2.2";
  sha256 = "265dbb5bc6d67bfeefa4a2a4ac9e5018d6d8b5c1a75816e05da2661c43a39bba";
  extraBuildInputs = [happy alex];
  propagatedBuildInputs =
    [QuickCheck binary haskeline haskellSrc mtl utf8String xhtml zlib];
  meta = {
    description = "A dependently typed functional language and proof assistant";
  };
})  

