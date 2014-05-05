{ cabal, contravariant, distributive, doctest, filepath, semigroups
, tagged, transformers
}:

cabal.mkDerivation (self: {
  pname = "comonad";
  version = "4.2";
  sha256 = "161dgmjfff85sj6yijzgzyb4dvnn1zsm3q5q96qwypynj0am5sr7";
  buildDepends = [
    contravariant distributive semigroups tagged transformers
  ];
  testDepends = [ doctest filepath ];
  meta = {
    homepage = "http://github.com/ekmett/comonad/";
    description = "Comonads";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
