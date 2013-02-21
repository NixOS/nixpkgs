{ cabal, semigroups, transformers }:

cabal.mkDerivation (self: {
  pname = "comonad";
  version = "3.0.1.1";
  sha256 = "01zqxrqxy6x6nf6rynzmncbhlgbbpshhw10pkimnw5isg3b8qhc2";
  buildDepends = [ semigroups transformers ];
  meta = {
    homepage = "http://github.com/ekmett/comonad/";
    description = "Haskell 98 compatible comonads";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
