{ cabal, filepath }:

cabal.mkDerivation (self: {
  pname = "funcmp";
  version = "1.7";
  sha256 = "1rna7x7lw36fv5pyq0zn4b472mh11r0bszzji13wm3byhhmzs04k";
  buildDepends = [ filepath ];
  meta = {
    homepage = "http://savannah.nongnu.org/projects/funcmp/";
    description = "Functional MetaPost";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
