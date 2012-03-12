{ cabal, deepseq, hashable }:

cabal.mkDerivation (self: {
  pname = "unordered-containers";
  version = "0.2.0.1";
  sha256 = "16vql5s98w9gfzjngzq0a18d173l67jcrib18fh0bxdibmg9hzql";
  buildDepends = [ deepseq hashable ];
  meta = {
    description = "Efficient hashing-based container types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
