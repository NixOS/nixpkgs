{ cabal, attoparsec, either, hoodleTypes, lens, mtl, strict, text
, transformers, xournalTypes
}:

cabal.mkDerivation (self: {
  pname = "hoodle-parser";
  version = "0.2.2";
  sha256 = "1m0jf7820hkdq69866hwqd1cc6rv331jrar8ayr28692h09j02rm";
  buildDepends = [
    attoparsec either hoodleTypes lens mtl strict text transformers
    xournalTypes
  ];
  jailbreak = true;
  meta = {
    homepage = "http://ianwookim.org/hoodle";
    description = "Hoodle file parser";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ianwookim ];
  };
})
