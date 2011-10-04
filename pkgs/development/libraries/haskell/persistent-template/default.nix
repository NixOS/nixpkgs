{ cabal, monadControl, persistent, text }:

cabal.mkDerivation (self: {
  pname = "persistent-template";
  version = "0.6.3";
  sha256 = "1vcjvfjxmv9c0wg7pbx0lw73128f5y0r4sfdsyq3jrkkiq1bgsxa";
  buildDepends = [ monadControl persistent text ];
  meta = {
    homepage = "http://www.yesodweb.com/book/persistent";
    description = "Type-safe, non-relational, multi-backend persistence";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
