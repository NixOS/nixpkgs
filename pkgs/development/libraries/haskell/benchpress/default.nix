{ cabal, mtl, time }:

cabal.mkDerivation (self: {
  pname = "benchpress";
  version = "0.2.2.6";
  sha256 = "19ygaf2g4yqkfbc6bw6fmf9jsymbj1iallzvl0zw3vjx860rchfg";
  buildDepends = [ mtl time ];
  meta = {
    homepage = "http://github.com/tibbe/benchpress";
    description = "Micro-benchmarking with detailed statistics";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
