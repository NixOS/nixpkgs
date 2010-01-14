{cabal, QuickCheck, binary, haskeline, haskellSrc, mtl, utf8String, xhtml, zlib,
 happy, alex}:

cabal.mkDerivation (self : {
  pname = "Agda";
  version = "2.2.6";
  sha256 = "e9268a61db30fc0f22f7e1fbc78673cd3e0d1bf2dd40ee5cf809635ca40fca78";
  extraBuildInputs = [happy alex];
  propagatedBuildInputs =
    [QuickCheck binary haskeline haskellSrc mtl utf8String xhtml zlib];
  meta = {
    description = "A dependently typed functional language and proof assistant";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

