{ cabal, mtl, time }:

cabal.mkDerivation (self: {
  pname = "benchpress";
  version = "0.2.2.5";
  sha256 = "0md66nnn9ad8f3y0dd411plnza59fvhfd6nibag3a556bpfa0kgs";
  buildDepends = [ mtl time ];
  patchPhase = ''
    sed -i -e 's|mtl .*,|mtl,|' benchpress.cabal
  '';
  meta = {
    homepage = "http://github.com/tibbe/benchpress";
    description = "Micro-benchmarking with detailed statistics";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
