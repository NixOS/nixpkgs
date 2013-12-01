{ cabal, cmdargs, diffutils, doctest, filepath, hspec, lens, mtl
, syb
}:

cabal.mkDerivation (self: {
  pname = "HList";
  version = "0.3.0.1";
  sha256 = "03mp99pb8whh3whyffyj8wbld8lv8i930dyjdpyfwiaj13x05iy4";
  buildDepends = [ mtl ];
  testDepends = [ cmdargs doctest filepath hspec lens mtl syb ];
  buildTools = [ diffutils ];
  meta = {
    description = "Heterogeneous lists";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
