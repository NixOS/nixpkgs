{ cabal, parsec, shakespeare, text }:

cabal.mkDerivation (self: {
  pname = "shakespeare-i18n";
  version = "0.0.0";
  sha256 = "1zyr63ncd92c30afh0sf4lq7p253jd3gjvcv65f7i0njqpc1lg9y";
  buildDepends = [ parsec shakespeare text ];
  meta = {
    homepage = "http://www.yesodweb.com/book/i18n";
    description = "A type-based approach to internationalization";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
