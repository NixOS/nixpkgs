{ cabal, hspec, HUnit, shakespeare, text }:

cabal.mkDerivation (self: {
  pname = "shakespeare-text";
  version = "1.0.2";
  sha256 = "0vhk5g5pm3gz8gzr7cbvkp920x4lmb9pkb9k6yhlj8wfb93bg93q";
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
