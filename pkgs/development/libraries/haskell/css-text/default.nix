{ cabal, attoparsec, hspec, QuickCheck, text }:

cabal.mkDerivation (self: {
  pname = "css-text";
  version = "0.1.2.0.1";
  sha256 = "0j8d9kfs9j01gqlapaahyziphkx0f55g9bbz2wwix1si7954xxhp";
  buildDepends = [ attoparsec text ];
  testDepends = [ attoparsec hspec QuickCheck text ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "CSS parser and renderer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
