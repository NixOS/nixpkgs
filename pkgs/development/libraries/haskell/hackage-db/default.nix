{ cabal, tar }:

cabal.mkDerivation (self: {
  pname = "hackage-db";
  version = "1.3";
  sha256 = "17l2aw2kzjpjzyrg0c5vlaglx0vl475g3wxwavvzrd60z9lb3cp9";
  buildDepends = [ tar ];
  meta = {
    homepage = "http://github.com/peti/hackage-db";
    description = "provide access to the Hackage database via Data.Map";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
