{ cabal, QuickCheck }:

cabal.mkDerivation (self: {
  pname = "pathtype";
  version = "0.5.2";
  sha256 = "0rbmq6kzz2l07q9a5k888scpn62hnw2hmzz4ysprhfgdnn5b2cvi";
  buildDepends = [ QuickCheck ];
  meta = {
    homepage = "http://code.haskell.org/pathtype";
    description = "Type-safe replacement for System.FilePath etc";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
