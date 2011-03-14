{cabal, QuickCheck, binary, haskeline, haskellSrcExts, mtl, utf8String,
 syb, xhtml, zlib,
 happy, alex}:

cabal.mkDerivation (self : {
  pname = "Agda";
  version = "2.2.10";
  sha256 = "1bh96g5c6b6jzaf3m9gm0vr64avgi86kb45p8i1vg1jbfjdbdlsw";
  extraBuildInputs = [happy alex];
  propagatedBuildInputs =
    [QuickCheck binary haskeline haskellSrcExts mtl utf8String
     syb xhtml zlib];
  meta = {
    description = "A dependently typed functional language and proof assistant";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

