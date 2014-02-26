{ cabal, aeson, Cabal, deepseq, either, filepath, haskellSrcExts
, hseCpp, mtl, optparseApplicative, tagged
}:

cabal.mkDerivation (self: {
  pname = "haskell-packages";
  version = "0.2.3.4";
  sha256 = "0qj5n1yc481n5c8gi5dgk22pxj58gf7z30621spr7gwlv001sk1y";
  buildDepends = [
    aeson Cabal deepseq either filepath haskellSrcExts hseCpp mtl
    optparseApplicative tagged
  ];
  meta = {
    homepage = "http://documentup.com/haskell-suite/haskell-packages";
    description = "Haskell suite library for package management and integration with Cabal";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
