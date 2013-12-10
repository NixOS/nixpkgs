{ cabal, HUnit, QuickCheck, random, text, vector }:

cabal.mkDerivation (self: {
  pname = "ListLike";
  version = "4.0.1";
  sha256 = "1ny6h3f1l0gigyv2rs24s7w158vsflrdx4i9v1al4910cxh56awv";
  buildDepends = [ text vector ];
  testDepends = [ HUnit QuickCheck random text vector ];
  jailbreak = true;
  meta = {
    homepage = "http://software.complete.org/listlike";
    description = "Generic support for list-like structures";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
