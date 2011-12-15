{ cabal, haskellSrcExts, syb, thLift }:

cabal.mkDerivation (self: {
  pname = "haskell-src-meta";
  version = "0.5.0.2";
  sha256 = "059zvr91bnajql19c76vwivvy6sbca83ky8ja91bf8xv1p3jfz3w";
  buildDepends = [ haskellSrcExts syb thLift ];
  meta = {
    description = "Parse source to template-haskell abstract syntax";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
