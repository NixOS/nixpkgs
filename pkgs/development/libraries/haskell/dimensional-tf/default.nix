{ cabal, numtypeTf, time }:

cabal.mkDerivation (self: {
  pname = "dimensional-tf";
  version = "0.2.1";
  sha256 = "1avvq8kgxagdw3345y7ly30i4x43l0i0m43rlb72j3inv6rdgxgz";
  buildDepends = [ numtypeTf time ];
  meta = {
    homepage = "http://dimensional.googlecode.com/";
    description = "Statically checked physical dimensions, implemented using type families";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
