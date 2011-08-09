{ cabal, fuse }:

cabal.mkDerivation (self: {
  pname = "HFuse";
  version = "0.2.4";
  sha256 = "1v3kfkm2rz7bvwk0j8p9rhnnsffbnkismnsq0fkgnzi5z0bz5sgv";
  extraLibraries = [ fuse ];
  meta = {
    homepage = "https://github.com/realdesktop/hfuse";
    description = "HFuse is a binding for the Linux FUSE library.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
