{ cabal, happstackServer, mtl, text }:

cabal.mkDerivation (self: {
  pname = "happstack-lite";
  version = "7.3.3";
  sha256 = "0iv60cch0fiy9kh21wcpk3s4nvd4j2p50pqr3y56bsqwxk53hhv8";
  buildDepends = [ happstackServer mtl text ];
  meta = {
    homepage = "http://www.happstack.com/";
    description = "Happstack minus the useless stuff";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
