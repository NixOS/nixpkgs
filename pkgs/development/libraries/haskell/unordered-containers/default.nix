{cabal, deepseq, hashable} :

cabal.mkDerivation (self : {
  pname = "unordered-containers";
  version = "0.1.4.2";
  sha256 = "0nfw82zng9y5dinjn78k05i4c4bjc1y6yb2dwqwczb85hbrqiha6";
  propagatedBuildInputs = [ deepseq hashable ];
  meta = {
    description = "Efficient hashing-based container types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [
      self.stdenv.lib.maintainers.simons
      self.stdenv.lib.maintainers.andres
    ];
  };
})
