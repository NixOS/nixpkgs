{cabal, gtk2hsBuildtools, pkgconfig, glibc, cairo, zlib, mtl}:

cabal.mkDerivation (self : {
  pname = "cairo";
  version = "0.12.0";
  sha256 = "0n2sqbf8wjjvm5m1igkq685vqvc0lil3gmcs3i0g9hy7lsjnlwr9";
  extraBuildInputs = [pkgconfig glibc cairo zlib gtk2hsBuildtools];
  propagatedBuildInputs = [mtl];
  meta = {
    description = "Binding to the Cairo library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
