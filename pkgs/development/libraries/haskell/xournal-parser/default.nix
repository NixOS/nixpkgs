{ cabal, attoparsec, attoparsecConduit, conduit, lens, mtl, strict
, text, transformers, xmlConduit, xmlTypes, xournalTypes
, zlibConduit
}:

cabal.mkDerivation (self: {
  pname = "xournal-parser";
  version = "0.5.0.2";
  sha256 = "1s9z7s6mcsn4s2krrcb1x63ca1d0rpyzdhb147w9524qw7gvbjin";
  buildDepends = [
    attoparsec attoparsecConduit conduit lens mtl strict text
    transformers xmlConduit xmlTypes xournalTypes zlibConduit
  ];
  jailbreak = true;
  meta = {
    homepage = "http://ianwookim.org/hoodle";
    description = "Xournal file parser";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ianwookim ];
  };
})
