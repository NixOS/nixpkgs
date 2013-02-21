{ cabal, aeson, conduit, monadControl, monadLogger, persistent
, text, transformers
}:

cabal.mkDerivation (self: {
  pname = "persistent-sqlite";
  version = "1.1.4";
  sha256 = "1xllj5bq7rw9v32ddm515705nviarw0hp4yxj0z8jf5q5jdz2vz0";
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
