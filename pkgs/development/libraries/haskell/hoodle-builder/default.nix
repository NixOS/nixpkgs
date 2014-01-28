{ cabal, blazeBuilder, doubleConversion, hoodleTypes, lens, strict
}:

cabal.mkDerivation (self: {
  pname = "hoodle-builder";
  version = "0.2.2.0";
  sha256 = "0p123jpm39ggbjn1757nfygcgi324knin62cyggbq1hhhglkfxa2";
  buildDepends = [
    blazeBuilder doubleConversion hoodleTypes lens strict
  ];
  jailbreak = true;
  meta = {
    description = "text builder for hoodle file format";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ianwookim ];
  };
})
