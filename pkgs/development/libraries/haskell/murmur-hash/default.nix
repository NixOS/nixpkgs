{ cabal }:

cabal.mkDerivation (self: {
  pname = "murmur-hash";
  version = "0.1.0.4";
  sha256 = "08nvdv3r5scqpdcivwp0d77dl4vpkgq58rzxv1xpb8r1krqy588d";
  meta = {
    homepage = "http://github.com/nominolo/murmur-hash";
    description = "MurmurHash2 implementation for Haskell.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
