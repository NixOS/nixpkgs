{ cabal }:

cabal.mkDerivation (self: {
  pname = "fingertree";
  version = "0.0.1.1";
  sha256 = "00llr24b2r539250fangl0jj39gf26gjwvhjpy5qg8l920hrjn78";
  meta = {
    description = "Generic finger-tree structure, with example instances";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
