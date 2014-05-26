{ cabal, dlist, fmlist, HUnit, QuickCheck, random, text, vector }:

cabal.mkDerivation (self: {
  pname = "ListLike";
  version = "4.1.0";
  sha256 = "0j78mm9vsl3scwgqp4h2bhq54hf22bxj9cg9pl26d12zw7038kwj";
  buildDepends = [ dlist fmlist text vector ];
  testDepends = [ dlist fmlist HUnit QuickCheck random text vector ];
  jailbreak = true;
  meta = {
    homepage = "http://software.complete.org/listlike";
    description = "Generic support for list-like structures";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
