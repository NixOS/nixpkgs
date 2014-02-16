{ cabal, hspec, HUnit, shakespeare, text }:

cabal.mkDerivation (self: {
  pname = "shakespeare-text";
  version = "1.0.1";
  sha256 = "1vxy1d8r9wd8qijmy2jm7c7y7wg77qnzsh1ga0rlh3nklj9w01ml";
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
