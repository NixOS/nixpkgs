{ cabal, binary, blas, gsl, HUnit, liblapack, QuickCheck, random
, storableComplex, vector
}:

cabal.mkDerivation (self: {
  pname = "hmatrix";
  version = "0.12.0.0";
  sha256 = "1j4c3my6i3xz6b4pyy98722zmgky27ls7a7w13ilwmnhb7pvq9al";
  buildDepends = [
    binary HUnit QuickCheck random storableComplex vector
  ];
  extraLibraries = [ blas gsl liblapack ];
  meta = {
    homepage = "http://perception.inf.um.es/hmatrix";
    description = "Linear algebra and numerical computation";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.guibert
      self.stdenv.lib.maintainers.simons
    ];
  };
})
