{ cabal, fay }:

cabal.mkDerivation (self: {
  pname = "fay-base";
  version = "0.18.0.0";
  sha256 = "010zjcs4y0zdb4gijrw10sjc56i271s35bkwg5c0lblyr62nml0s";
  buildDepends = [ fay ];
  meta = {
    homepage = "https://github.com/faylang/fay-base";
    description = "The base package for Fay";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
