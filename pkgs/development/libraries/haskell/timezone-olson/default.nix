{ cabal, binary, extensibleExceptions, time, timezoneSeries }:

cabal.mkDerivation (self: {
  pname = "timezone-olson";
  version = "0.1.3";
  sha256 = "02x3wq03h2zjhxrcv6vnq9hrzggdvpnj7zj8rcrq4scf67q6h8gc";
  buildDepends = [ binary extensibleExceptions time timezoneSeries ];
  meta = {
    homepage = "http://projects.haskell.org/time-ng/";
    description = "A pure Haskell parser and renderer for binary Olson timezone files";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
