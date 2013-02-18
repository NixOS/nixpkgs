{ cabal, aeson, conduit, monadControl, persistent, text
, transformers
}:

cabal.mkDerivation (self: {
  pname = "persistent-sqlite";
  version = "1.1.3";
  sha256 = "0rhwq9s6w48y867dmy5c0kvgrh9ixy3sqwq1i2zfacak82r6kki1";
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
