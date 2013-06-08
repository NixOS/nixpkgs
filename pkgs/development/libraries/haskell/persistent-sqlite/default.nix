{ cabal, aeson, conduit, monadControl, monadLogger, persistent
, text, transformers
}:

cabal.mkDerivation (self: {
  pname = "persistent-sqlite";
  version = "1.2.0";
  sha256 = "09xd9z16rcq9ymx5ysshzdr30lih55b9kasvbq5xw6wq7lvg6q4h";
  buildDepends = [
    aeson conduit monadControl monadLogger persistent text transformers
  ];
  meta = {
    homepage = "http://www.yesodweb.com/book/persistent";
    description = "Backend for the persistent library using sqlite3";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
