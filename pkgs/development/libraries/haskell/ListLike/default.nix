{ cabal, HUnit, QuickCheck, random, text, vector }:

cabal.mkDerivation (self: {
  pname = "ListLike";
  version = "4.0.0";
  sha256 = "13dw8pkj8dwxb81gbcm7gn221zyr3ck9s9s1iv7v1b69chv0zyxk";
  buildDepends = [ text vector ];
  testDepends = [ HUnit QuickCheck random text vector ];
  meta = {
    homepage = "http://software.complete.org/listlike";
    description = "Generic support for list-like structures";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
