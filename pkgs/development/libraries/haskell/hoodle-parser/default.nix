{ cabal, attoparsec, either, hoodleTypes, lens, mtl, strict, text
, transformers, xournalTypes
}:

cabal.mkDerivation (self: {
  pname = "hoodle-parser";
  version = "0.3";
  sha256 = "1ihpmkhjzsf8w4ygljx2agx31xblc0ch4y8m9pwj7rnnjj1sw15i";
  buildDepends = [
    attoparsec either hoodleTypes lens mtl strict text transformers
    xournalTypes
  ];
  meta = {
    homepage = "http://ianwookim.org/hoodle";
    description = "Hoodle file parser";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ianwookim ];
  };
})
