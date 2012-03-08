{ cabal, deepseq, hashable }:

cabal.mkDerivation (self: {
  pname = "unordered-containers";
  version = "0.2.0.0";
  sha256 = "1fan2qrfzdg1a5xnqncy4vs5xab2v3v4v1gvk50vjfj87valxnx4";
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
