{ cabal, hspec, HUnit, shakespeare, text }:

cabal.mkDerivation (self: {
  pname = "shakespeare-text";
  version = "1.0.0.7";
  sha256 = "0vl8884a0x927svvkza5xzjn4g1rip8dak1zh9wkm4d0q7lhv2px";
  buildDepends = [ shakespeare text ];
  testDepends = [ hspec HUnit text ];
  meta = {
    homepage = "http://www.yesodweb.com/book/shakespearean-templates";
    description = "Interpolation with quasi-quotation: put variables strings";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
