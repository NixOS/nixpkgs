{cabal, QuickCheck, binary, haskeline, haskellSrc, mtl, utf8String, xhtml, zlib,
 happy, alex}:

cabal.mkDerivation (self : {
  pname = "Agda";
  version = "2.2.8";
  sha256 = "06j2s7x3h5lanygd6mhhxkzjf4c0m8pw6c0s7gbmwlxqrkz9firg";
  extraBuildInputs = [happy alex];
  propagatedBuildInputs =
    [QuickCheck binary haskeline haskellSrc mtl utf8String xhtml zlib];
  meta = {
    description = "A dependently typed functional language and proof assistant";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

