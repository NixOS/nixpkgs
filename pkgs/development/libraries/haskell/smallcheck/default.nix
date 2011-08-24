{ cabal }:

cabal.mkDerivation (self: {
  pname = "smallcheck";
  version = "0.4";
  sha256 = "0nq13jm3akrmgk6n2clisip16v0jf1xkm0hm678v63s87hxqb1ma";
  meta = {
    description = "Another lightweight testing library in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
