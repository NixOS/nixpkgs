{ cabal, syb }:

cabal.mkDerivation (self: {
  pname = "hs-bibutils";
  version = "4.12";
  sha256 = "0akxi69as7k5c0955yla9wcl1xvcvgzpzy3p1jj781w1lf89p537";
  buildDepends = [ syb ];
  meta = {
    homepage = "http://code.haskell.org/hs-bibutils";
    description = "Haskell bindings to bibutils, the bibliography conversion utilities";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
