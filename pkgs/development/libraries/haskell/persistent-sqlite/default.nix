{ cabal, aeson, conduit, monadControl, persistent, text
, transformers
}:

cabal.mkDerivation (self: {
  pname = "persistent-sqlite";
  version = "1.0.1";
  sha256 = "1qvyxvmy37iy3q0frmy3zcklhms2rpjplw0fhk37cmgmw0bj2b7m";
  buildDepends = [
    aeson conduit monadControl persistent text transformers
  ];
  meta = {
    homepage = "http://www.yesodweb.com/book/persistent";
    description = "Backend for the persistent library using sqlite3";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
