{ cabal, binary, extensibleExceptions, time, timezoneSeries }:

cabal.mkDerivation (self: {
  pname = "timezone-olson";
  version = "0.1.2";
  sha256 = "1dp0nppvx732c27pybbyqw6jkx4kdgfc6vnc539m0xv005afpq9y";
  buildDepends = [ binary extensibleExceptions time timezoneSeries ];
  meta = {
    homepage = "http://projects.haskell.org/time-ng/";
    description = "A pure Haskell parser and renderer for binary Olson timezone files";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
