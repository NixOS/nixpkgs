{ cabal, Cabal }:

cabal.mkDerivation (self: {
  pname = "Diff";
  version = "0.1.3";
  sha256 = "02dhy4rp3mkzm5x3h1rkdin2h8qcb7h7nhn14gl2gvl6wdykfh5w";
  buildDepends = [ Cabal ];
  meta = {
    description = "O(ND) diff algorithm in haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
