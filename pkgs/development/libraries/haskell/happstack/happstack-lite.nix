{ cabal, happstackServer, mtl, text }:

cabal.mkDerivation (self: {
  pname = "happstack-lite";
  version = "7.3.1";
  sha256 = "0y8d0xv26szfjmkfqzak19zqjgv0w6rkc1rzrd2jkvsbchnwacjy";
  buildDepends = [ happstackServer mtl text ];
  meta = {
    homepage = "http://www.happstack.com/";
    description = "Happstack minus the useless stuff";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
