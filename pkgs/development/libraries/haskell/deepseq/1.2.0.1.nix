{ cabal }:

cabal.mkDerivation (self: {
  pname = "deepseq";
  version = "1.2.0.1";
  sha256 = "0r7lkqhllj7phmn4sq836fmis4wy9fpka4hjzhqzhbbykzys0z7d";
  meta = {
    description = "Deep evaluation of data structures";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
