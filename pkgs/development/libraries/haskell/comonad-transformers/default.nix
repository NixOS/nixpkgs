{ cabal, comonad, contravariant, distributive, semigroupoids
, semigroups, transformers
}:

cabal.mkDerivation (self: {
  pname = "comonad-transformers";
  version = "3.0.1";
  sha256 = "1lmcz01zsgy0lfzsznqbdq83vlk6h10zs7i41nav8qhzzhjn095j";
  buildDepends = [
    comonad contravariant distributive semigroupoids semigroups
    transformers
  ];
  meta = {
    homepage = "http://github.com/ekmett/comonad-transformers/";
    description = "Comonad transformers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
