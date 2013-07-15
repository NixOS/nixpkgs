{ cabal, doctest, filepath, semigroups, tagged, transformers }:

cabal.mkDerivation (self: {
  pname = "comonad";
  version = "3.1";
  sha256 = "0sl9b3f1vwpjdvnrxv7b8n512w05pv4in6qx3l4sbksdp1zjvcyv";
  buildDepends = [ semigroups tagged transformers ];
  testDepends = [ doctest filepath ];
  meta = {
    homepage = "http://github.com/ekmett/comonad/";
    description = "Haskell 98 compatible comonads";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
