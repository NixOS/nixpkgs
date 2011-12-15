{ cabal }:

cabal.mkDerivation (self: {
  pname = "cereal";
  version = "0.3.5.0";
  sha256 = "0bqkb9al8mr0dzik17bcrjdsk414x78wfc919jb17ihcg7gnvrg8";
  meta = {
    description = "A binary serialization library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
