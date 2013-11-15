{ cabal, async, smallcheck, tagged, tasty }:

cabal.mkDerivation (self: {
  pname = "tasty-smallcheck";
  version = "0.2";
  sha256 = "1xw0l1bikwavyq7s8q71a92x87mg7z65mk32nn5qx0zxwqsfb5l4";
  buildDepends = [ async smallcheck tagged tasty ];
  meta = {
    homepage = "https://github.com/feuerbach/tasty";
    description = "SmallCheck support for the Tasty test framework";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
