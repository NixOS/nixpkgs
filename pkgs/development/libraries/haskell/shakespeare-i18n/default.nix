{ cabal, parsec, shakespeare, text }:

cabal.mkDerivation (self: {
  pname = "shakespeare-i18n";
  version = "0.0.2.1";
  sha256 = "1gaxngqihz6wi5d6hyb9mdlhgcxnr4bvmm1si919zgjndwnms8z8";
  buildDepends = [ parsec shakespeare text ];
  meta = {
    homepage = "http://www.yesodweb.com/book/i18n";
    description = "A type-based approach to internationalization";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
