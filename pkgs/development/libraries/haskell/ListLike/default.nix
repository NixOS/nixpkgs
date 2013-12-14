{ cabal, HUnit, QuickCheck, random, text, vector }:

cabal.mkDerivation (self: {
  pname = "ListLike";
  version = "4.0.2";
  sha256 = "1ggh8yndnsmccgsl11fia4v2cad0vq3clibgh0311r3c43mwvnah";
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
