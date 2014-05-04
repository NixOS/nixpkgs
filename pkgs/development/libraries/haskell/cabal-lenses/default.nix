{ cabal, Cabal, lens, unorderedContainers }:

cabal.mkDerivation (self: {
  pname = "cabal-lenses";
  version = "0.1";
  sha256 = "0jss4h7crh7mndl5ghbpziy37cg9i29cc64fgxvxb63hpk0q2m17";
  buildDepends = [ Cabal lens unorderedContainers ];
  meta = {
    description = "Lenses and traversals for the Cabal library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
