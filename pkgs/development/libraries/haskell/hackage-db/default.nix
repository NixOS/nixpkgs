{ cabal, tar }:

cabal.mkDerivation (self: {
  pname = "hackage-db";
  version = "1.0";
  sha256 = "0y769ssr9jlyzcdr0l8wh5s3ivc3zbp9mf7xy7vnq6mr9hjh7lcw";
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
