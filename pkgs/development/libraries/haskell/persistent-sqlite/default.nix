{ cabal, aeson, conduit, monadControl, persistent, text
, transformers
}:

cabal.mkDerivation (self: {
  pname = "persistent-sqlite";
  version = "1.1.2";
  sha256 = "0pb52k7a7js71s4d2mynd62i8gk99az7y72rycs0xg9r9cr081p3";
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
