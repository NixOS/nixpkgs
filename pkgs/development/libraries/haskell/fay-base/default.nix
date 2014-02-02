{ cabal, fay }:

cabal.mkDerivation (self: {
  pname = "fay-base";
  version = "0.19";
  sha256 = "03jf1ig3s2dcdd26j3d3iwm9hbiq5f5q5hyg22jdvl7lmvigw36j";
  buildDepends = [ fay ];
  meta = {
    homepage = "https://github.com/faylang/fay-base";
    description = "The base package for Fay";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
