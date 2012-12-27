{ cabal }:

cabal.mkDerivation (self: {
  pname = "ghc-paths";
  version = "0.1.0.9";
  sha256 = "0ibrr1dxa35xx20cpp8jzgfak1rdmy344dfwq4vlq013c6w8z9mg";
  patches = [ ./ghc-paths-nix.patch ];
  meta = {
    description = "Knowledge of GHC's installation directories";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
