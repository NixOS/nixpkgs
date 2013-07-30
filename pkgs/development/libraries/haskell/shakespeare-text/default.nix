{ cabal, hspec, HUnit, shakespeare, text }:

cabal.mkDerivation (self: {
  pname = "shakespeare-text";
  version = "1.0.0.6";
  sha256 = "1qlf51rpyzgnxdhyfs6g3vh8zq5vyq263qhm577w7rc9s4hjxk45";
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
