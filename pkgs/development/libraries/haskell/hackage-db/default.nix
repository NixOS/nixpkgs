{ cabal, Cabal, filepath, tar, utf8String }:

cabal.mkDerivation (self: {
  pname = "hackage-db";
  version = "1.5";
  sha256 = "1m7f6vwgjzibk8rd14y6m62xv5969ns94a57sansi9d83q6rj9iv";
  buildDepends = [ Cabal filepath tar utf8String ];
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
