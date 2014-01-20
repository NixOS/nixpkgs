{ cabal, blazeBuilder, doubleConversion, hoodleTypes, lens, strict
}:

cabal.mkDerivation (self: {
  pname = "hoodle-builder";
  version = "0.2.2";
  sha256 = "0gagfpjihf6lafi90r883n9agaj1pw4gygaaxv4xxfsc270855bq";
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
