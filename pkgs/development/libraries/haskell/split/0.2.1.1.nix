{ cabal, QuickCheck }:

cabal.mkDerivation (self: {
  pname = "split";
  version = "0.2.1.1";
  sha256 = "1zzp4dwf846s74a4lhw2gf4awsk9iblhl5zcg2zccgv1lr4w2dmz";
  testDepends = [ QuickCheck ];
  meta = {
    description = "Combinator library for splitting lists";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
