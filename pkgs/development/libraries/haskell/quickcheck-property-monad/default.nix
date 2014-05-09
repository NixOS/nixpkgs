{ cabal, doctest, either, filepath, QuickCheck, transformers }:

cabal.mkDerivation (self: {
  pname = "quickcheck-property-monad";
  version = "0.2.1";
  sha256 = "1ln8bcsc8hd8jyhd9rp2j90p5h5nhmwidb5my91p09h43y4z9xds";
  buildDepends = [ either QuickCheck transformers ];
  testDepends = [ doctest filepath QuickCheck ];
  meta = {
    homepage = "http://github.com/bennofs/quickcheck-property-monad/";
    description = "quickcheck-property-monad";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
