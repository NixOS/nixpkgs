{ cabal, tar }:

cabal.mkDerivation (self: {
  pname = "hackage-db";
  version = "1.2";
  sha256 = "1dsm8mp8f6z7jqqgx39xfvl5kql6bbwxk25k435rsb685q9hzpxq";
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
