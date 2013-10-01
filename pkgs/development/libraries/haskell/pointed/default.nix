{ cabal, comonad, comonadTransformers, dataDefault, semigroupoids
, semigroups, stm, tagged, transformers
}:

cabal.mkDerivation (self: {
  pname = "pointed";
  version = "3.1";
  sha256 = "13vx1vy3qfa23145fdfdivdmw01qyl2k6g8ynqxl8pzbj9cbb08n";
  buildDepends = [
    comonad comonadTransformers dataDefault semigroupoids semigroups
    stm tagged transformers
  ];
  meta = {
    homepage = "http://github.com/ekmett/pointed/";
    description = "Haskell 98 pointed and copointed data";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
