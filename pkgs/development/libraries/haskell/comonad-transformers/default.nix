{ cabal, comonad, contravariant, distributive, semigroupoids
, semigroups, transformers
}:

cabal.mkDerivation (self: {
  pname = "comonad-transformers";
  version = "3.0.3";
  sha256 = "1q11xasl90z8sv9f7h77dxjsi2cwnjxqpaf0n5pvzn88nz9h6g66";
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
