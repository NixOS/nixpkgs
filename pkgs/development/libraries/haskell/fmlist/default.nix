{ cabal }:

cabal.mkDerivation (self: {
  pname = "fmlist";
  version = "0.8";
  sha256 = "1knr9yh58fwjpkm37hvrqghlchf5qibwf9q52app6zh3ys999rrs";
  meta = {
    description = "FoldMap lists";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
