{ cabal, time }:

cabal.mkDerivation (self: {
  pname = "timezone-series";
  version = "0.1.2";
  sha256 = "0clvm1kwmxid5bhb74vgrpzynn4sff2k6mfzb43i7737w5fy86gp";
  buildDepends = [ time ];
  meta = {
    homepage = "http://projects.haskell.org/time-ng/";
    description = "Enhanced timezone handling for Data.Time";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
