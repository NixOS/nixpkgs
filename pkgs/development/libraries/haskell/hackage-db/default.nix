{ cabal, Cabal, filepath, tar }:

cabal.mkDerivation (self: {
  pname = "hackage-db";
  version = "1.4";
  sha256 = "12z1ak21xc9v373j956gz8l4ryj0582lgbl9ykp8q46n9b8sxfph";
  buildDepends = [ Cabal filepath tar ];
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
