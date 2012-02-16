{ cabal, deepseq }:

cabal.mkDerivation (self: {
  pname = "parallel";
  version = "3.2.0.2";
  sha256 = "0sy67cdbwh17wng6b77h9hnkg59mgnyilwvirihmq9535jm9yml2";
  buildDepends = [ deepseq ];
  meta = {
    description = "Parallel programming library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
