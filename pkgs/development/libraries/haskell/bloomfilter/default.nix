{ cabal, deepseq }:

cabal.mkDerivation (self: {
  pname = "bloomfilter";
  version = "1.2.6.8";
  sha256 = "0qv25dfyqbkswcbw1cxs4zcm8zl0xi5880zx6fab8ka6vnx2a5nf";
  buildDepends = [ deepseq ];
  meta = {
    homepage = "http://www.serpentine.com/software/bloomfilter";
    description = "Pure and impure Bloom Filter implementations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
