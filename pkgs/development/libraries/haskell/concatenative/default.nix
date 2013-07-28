{ cabal }:

cabal.mkDerivation (self: {
  pname = "concatenative";
  version = "1.0.1";
  sha256 = "05xwqvcdnk8bsyj698ab9jxpa1nk23pf3m7wi9mwmw0q8n99fngd";
  meta = {
    homepage = "https://patch-tag.com/r/salazar/concatenative/snapshot/current/content/pretty";
    description = "A library for postfix control flow";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
