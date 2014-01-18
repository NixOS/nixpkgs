{ cabal, aeson, Cabal, deepseq, EitherT, filepath, haskellSrcExts
, hseCpp, mtl, optparseApplicative, tagged
}:

cabal.mkDerivation (self: {
  pname = "haskell-packages";
  version = "0.2.3.3";
  sha256 = "1i3x392dwryhw6k02bd2r9wn9iwwmcqzjhk7gx5lx1vhyb470qr2";
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
