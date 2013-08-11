{ cabal, Cabal, filepath, tar, utf8String }:

cabal.mkDerivation (self: {
  pname = "hackage-db";
  version = "1.7";
  sha256 = "0mf22xxbcbjb7l4jahknp6s7lsfn43ib7z9m2jsg9py92vkacfp1";
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
