{ cabal, contravariant, deepseq, doctest, filepath, hlint
, hybridVectors, lens_4_0, linear, mtl, primitive, QuickCheck
, semigroups, simpleReflect, testFramework
, testFrameworkQuickcheck2, testFrameworkTh, transformers, vector
, vectorAlgorithms_0_5_4_2
}:

cabal.mkDerivation (self: {
  pname = "sparse";
  version = "0.9";
  sha256 = "0v0z7kjgmcdx9ajlhr9pc1i3qqghd60s02xnlmj4hcxby8k0r8mc";
  buildDepends = [
    contravariant deepseq hybridVectors lens_4_0 primitive transformers
    vector vectorAlgorithms_0_5_4_2
  ];
  testDepends = [
    deepseq doctest filepath hlint hybridVectors lens_4_0 linear mtl
    QuickCheck semigroups simpleReflect testFramework
    testFrameworkQuickcheck2 testFrameworkTh transformers vector
  ];
  doCheck = false;
  meta = {
    homepage = "http://github.com/ekmett/sparse";
    description = "A playground of sparse linear algebra primitives using Morton ordering";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
