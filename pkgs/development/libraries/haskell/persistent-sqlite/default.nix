{ cabal, aeson, conduit, monadControl, monadLogger, persistent
, text, transformers
}:

cabal.mkDerivation (self: {
  pname = "persistent-sqlite";
  version = "1.2.1";
  sha256 = "1lbb8s6p3xixlkgwx30p473b438qjnw9s41bcm1q38vkklpa75y0";
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
