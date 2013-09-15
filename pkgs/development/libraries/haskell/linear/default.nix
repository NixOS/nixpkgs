{ cabal, distributive, doctest, filepath, hashable, lens
, reflection, semigroupoids, semigroups, simpleReflect, tagged
, transformers, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "linear";
  version = "1.2";
  sha256 = "0mna8k6plq0akki5j5zjk1xk1hgks1076q1h5s14v87d0h45wlrh";
  buildDepends = [
    distributive hashable reflection semigroupoids semigroups tagged
    transformers unorderedContainers vector
  ];
  testDepends = [ doctest filepath lens simpleReflect ];
  meta = {
    homepage = "http://github.com/ekmett/linear/";
    description = "Linear Algebra";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
