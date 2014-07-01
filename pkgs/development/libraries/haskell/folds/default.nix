{ cabal, comonad, contravariant, deepseq, doctest, filepath, hlint
, lens, mtl, pointed, profunctors, reflection, semigroupoids
, semigroups, tagged, transformers, vector
}:

cabal.mkDerivation (self: {
  pname = "folds";
  version = "0.6.1";
  sha256 = "13p4kyr48g917ib87n14qpqaka6isp73cwy7mvvsqgprj1fghyj1";
  buildDepends = [
    comonad contravariant lens pointed profunctors reflection
    semigroupoids tagged transformers vector
  ];
  testDepends = [ deepseq doctest filepath hlint mtl semigroups ];
  doCheck = false;
  meta = {
    homepage = "http://github.com/ekmett/folds";
    description = "Beautiful Folding";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
