{cabal, QuickCheck2}:

cabal.mkDerivation (self : {
  pname = "pathtype";
  version = "0.5.2";
  sha256 = "0rbmq6kzz2l07q9a5k888scpn62hnw2hmzz4ysprhfgdnn5b2cvi";
  propagatedBuildInputs = [QuickCheck2];
  meta = {
    license = "BSD";
    description = "Type-safe file path manipulations";
    maintainer = [self.stdenv.lib.maintainers.simons];
  };
})
