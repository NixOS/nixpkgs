{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "wl-pprint-text";
  version = "1.1.0.1";
  sha256 = "1rb5jmryxzcn6j8xalvsgwr61d1qzmsjyfp3iiq10n565bja70za";
  buildDepends = [ text ];
  meta = {
    description = "A Wadler/Leijen Pretty Printer for Text values";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
