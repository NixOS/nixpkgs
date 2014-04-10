{ cabal, cmdargs, diffutils, doctest, filepath, hspec, lens, mtl
, syb, tagged
}:

cabal.mkDerivation (self: {
  pname = "HList";
  version = "0.3.4.1";
  sha256 = "02hw496qv2p0nnbz7lq7jfqnis19qqjsylyvdksqbwmjprk32rh2";
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
