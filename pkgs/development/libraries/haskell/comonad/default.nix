{ cabal, doctest, filepath, semigroups, transformers }:

cabal.mkDerivation (self: {
  pname = "comonad";
  version = "3.0.2";
  sha256 = "0ryyifcxc5rmjrf9323zzj357709mah1hdsrnrbakd5ck7grjfay";
  buildDepends = [ semigroups transformers ];
  testDepends = [ doctest filepath ];
  meta = {
    homepage = "http://github.com/ekmett/comonad/";
    description = "Haskell 98 compatible comonads";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
