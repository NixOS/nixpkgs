{ cabal, aeson, conduit, monadControl, persistent, text
, transformers
}:

cabal.mkDerivation (self: {
  pname = "persistent-sqlite";
  version = "0.9.0";
  sha256 = "0l0w4g83bxaqlwwqs9xvlws0ksl0i8jmqsi4lpgywylvpywnhlgc";
  buildDepends = [
    aeson conduit monadControl persistent text transformers
  ];
  meta = {
    homepage = "http://www.yesodweb.com/book/persistent";
    description = "Backend for the persistent library using sqlite3";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
