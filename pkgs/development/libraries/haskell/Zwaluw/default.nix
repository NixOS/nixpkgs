{ cabal, Cabal }:

cabal.mkDerivation (self: {
  pname = "Zwaluw";
  version = "0.1";
  sha256 = "1crvcvni5gzpc1c6cnaqqp0gng1l9gk9d8ac23967nvp82xav7s1";
  buildDepends = [ Cabal ];
  meta = {
    homepage = "https://github.com/MedeaMelana/Zwaluw";
    description = "Combinators for bidirectional URL routing";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
