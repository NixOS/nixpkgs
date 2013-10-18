{ cabal, hspec, HUnit, shakespeare, text }:

cabal.mkDerivation (self: {
  pname = "shakespeare-text";
  version = "1.0.0.8";
  sha256 = "0gf4gsdfjz9c15wvxz886gjzzifgzanfhblgab15inl2rblirv7l";
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
