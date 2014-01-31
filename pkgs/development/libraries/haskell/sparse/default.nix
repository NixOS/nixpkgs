{ cabal, contravariant, deepseq, doctest, filepath, hlint
, hybridVectors, lens, linear, mtl, primitive, QuickCheck_2_5_1_1
, semigroups, simpleReflect, testFramework
, testFrameworkQuickcheck2, testFrameworkTh, transformers, vector
, vectorAlgorithms_0_5_4_2
}:

cabal.mkDerivation (self: {
  pname = "sparse";
  version = "0.7.0.1";
  sha256 = "0px0g1kk53kgky5rxj9vvdmyvqifabkgl73wjgj97hlfjnzn8fhb";
  buildDepends = [
    contravariant deepseq hybridVectors lens primitive transformers
    vector vectorAlgorithms_0_5_4_2
  ];
  testDepends = [
    deepseq doctest filepath hlint hybridVectors lens linear mtl
    QuickCheck_2_5_1_1 semigroups simpleReflect testFramework
    testFrameworkQuickcheck2 testFrameworkTh transformers vector
  ];
  doCheck = false; # Currently broken upstream.
  meta = {
    homepage = "http://github.com/ekmett/sparse";
    description = "A playground of sparse linear algebra primitives using Morton ordering";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
