{ cabal, cmdargs, diffutils, doctest, filepath, hspec, lens, mtl
, syb, tagged
}:

cabal.mkDerivation (self: {
  pname = "HList";
  version = "0.3.4.0";
  sha256 = "0jx0bfsc17c6bx621n7k0wfa5s59kcpi45p6wr8g4gyw846hjw9q";
  buildDepends = [ mtl tagged ];
  testDepends = [ cmdargs doctest filepath hspec lens mtl syb ];
  buildTools = [ diffutils ];
  doCheck = false;
  meta = {
    description = "Heterogeneous lists";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
