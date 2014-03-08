{ cabal, mtl, syb, thDesugar }:

cabal.mkDerivation (self: {
  pname = "singletons";
  version = "0.9.3";
  sha256 = "0m90k3ygm04c0gjfiaw5rmajyn2yz0ldcqm2xmm39d10270skpb4";
  buildDepends = [ mtl syb thDesugar ];
  noHaddock = true;
  meta = {
    homepage = "http://www.cis.upenn.edu/~eir/packages/singletons";
    description = "A framework for generating singleton types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
