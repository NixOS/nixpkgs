{ cabal, aeson, Cabal, deepseq, EitherT, filepath, haskellSrcExts
, hseCpp, mtl, optparseApplicative, tagged
}:

cabal.mkDerivation (self: {
  pname = "haskell-packages";
  version = "0.2.3.1";
  sha256 = "0sryw0gdwkgd53la6gryf7i5h8rlpys6j8nh75f9j014i4y1p0jw";
  buildDepends = [
    aeson Cabal deepseq EitherT filepath haskellSrcExts hseCpp mtl
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
