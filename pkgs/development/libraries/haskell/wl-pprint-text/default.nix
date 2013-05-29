{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "wl-pprint-text";
  version = "1.1.0.0";
  sha256 = "18xgsrxg20sk18m9dwds6161vl4hgdp052qbb0cg9jqy50vhddis";
  buildDepends = [ text ];
  meta = {
    description = "A Wadler/Leijen Pretty Printer for Text values";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
