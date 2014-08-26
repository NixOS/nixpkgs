{ cabal }:

cabal.mkDerivation (self: {
  pname = "old-time";
  version = "1.1.0.2";
  sha256 = "1nrqbpwxsmga13gcyn7bg25gkm61fmix07gm76d1f1i4impgqw1r";
  meta = {
    description = "Time library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
