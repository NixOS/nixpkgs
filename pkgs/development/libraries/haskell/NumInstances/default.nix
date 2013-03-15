{ cabal }:

cabal.mkDerivation (self: {
  pname = "NumInstances";
  version = "1.2";
  sha256 = "0s26j3h0xg16lcz95qs21iyfnzx8q8w2k2lnq55gakkr1wl4ap59";
  meta = {
    description = "Instances of numeric classes for functions and tuples";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
