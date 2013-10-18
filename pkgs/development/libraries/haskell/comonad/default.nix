{ cabal, contravariant, distributive, doctest, filepath, mtl
, semigroups, tagged, transformers
}:

cabal.mkDerivation (self: {
  pname = "comonad";
  version = "4.0";
  sha256 = "1f57wqxy1la59kippbj924prnj53a5hwc2ppg48n9xx2wfr63iha";
  buildDepends = [
    contravariant distributive mtl semigroups tagged transformers
  ];
  testDepends = [ doctest filepath ];
  meta = {
    homepage = "http://github.com/ekmett/comonad/";
    description = "Comonads";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
