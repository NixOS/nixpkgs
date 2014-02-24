{ cabal, aeson, Cabal, dataLens, dataLensTemplate, filemanip
, filepath, haskellPackages, haskellSrcExts, hseCpp, mtl
, prettyShow, tagged, tasty, tastyGolden, transformers
, traverseWithClass, typeEq, uniplate, utf8String
}:

cabal.mkDerivation (self: {
  pname = "haskell-names";
  version = "0.3.2.5";
  sha256 = "1jp3109b742gr6ii7syacl167i1i91xsyw0200ghaad3ymrqkcvq";
  buildDepends = [
    aeson Cabal dataLens dataLensTemplate filepath haskellPackages
    haskellSrcExts hseCpp mtl tagged transformers traverseWithClass
    typeEq uniplate
  ];
  testDepends = [
    aeson Cabal filemanip filepath haskellPackages haskellSrcExts
    hseCpp mtl prettyShow tagged tasty tastyGolden traverseWithClass
    uniplate utf8String
  ];
  doCheck = false;
  meta = {
    homepage = "http://documentup.com/haskell-suite/haskell-names";
    description = "Name resolution library for Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
