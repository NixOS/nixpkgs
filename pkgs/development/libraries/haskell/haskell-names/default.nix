{ cabal, aeson, Cabal, dataLens, dataLensTemplate, filemanip
, filepath, haskellPackages, haskellSrcExts, hseCpp, mtl
, prettyShow, tagged, tasty, tastyGolden, transformers
, traverseWithClass, typeEq, uniplate, utf8String
}:

cabal.mkDerivation (self: {
  pname = "haskell-names";
  version = "0.3.2.7";
  sha256 = "0ibc74xd480nnjhx274i184g2m24wx5ks602731fr490044cr4hl";
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
