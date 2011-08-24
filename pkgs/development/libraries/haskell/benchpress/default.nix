{ cabal, mtl, time }:

cabal.mkDerivation (self: {
  pname = "benchpress";
  version = "0.2.2.4";
  sha256 = "0cabjx0gkbk5blqkm9pmnz8kmi3573367365gny4r3m431iwxgnf";
  buildDepends = [ mtl time ];
  meta = {
    homepage = "http://github.com/tibbe/benchpress";
    description = "Micro-benchmarking with detailed statistics";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
