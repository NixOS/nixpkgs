{ cabal, contravariant, distributive, doctest, filepath, mtl
, semigroups, tagged, transformers
}:

cabal.mkDerivation (self: {
  pname = "comonad";
  version = "4.0.1";
  sha256 = "1ib3spgyjbdsnpbz4alaqb1m13v48l5dpv7s68c0mi2nyjkli7lx";
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
