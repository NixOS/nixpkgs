{ cabal, aeson, Cabal, dataLens, dataLensTemplate, filemanip
, filepath, haskellPackages, haskellSrcExts, hseCpp, mtl
, prettyShow, tagged, tasty, tastyGolden, transformers
, traverseWithClass, typeEq, uniplate, utf8String
}:

cabal.mkDerivation (self: {
  pname = "haskell-names";
  version = "0.3.2.6";
  sha256 = "1326p95r28hzzwcqjvqwwjxx8hcq56gd978v7g45jhvr73kpnzz6";
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
