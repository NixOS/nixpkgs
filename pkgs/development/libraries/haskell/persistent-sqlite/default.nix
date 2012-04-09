{ cabal, aeson, conduit, monadControl, persistent, text
, transformers
}:

cabal.mkDerivation (self: {
  pname = "persistent-sqlite";
  version = "0.9.0.1";
  sha256 = "19bwkaazg3c822n3308awy70ml40jvncr4c3rvidq72zzdvql9c2";
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
