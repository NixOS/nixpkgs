{ cabal, semigroups, transformers }:

cabal.mkDerivation (self: {
  pname = "comonad";
  version = "1.1.1.6";
  sha256 = "1sg0pa7393mzfm27pl52nchplhkls3k0f4ff8vzk76wzrgvhysg5";
  buildDepends = [ semigroups transformers ];
  meta = {
    homepage = "http://github.com/ekmett/comonad/";
    description = "Haskell 98 compatible comonads";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
