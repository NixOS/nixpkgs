{ cabal, contravariant, deepseq, doctest, filepath, hlint
, hybridVectors, lens, linear, mtl, primitive, QuickCheck
, semigroups, simpleReflect, testFramework
, testFrameworkQuickcheck2, testFrameworkTh, transformers, vector
, vectorAlgorithms
}:

cabal.mkDerivation (self: {
  pname = "sparse";
  version = "0.9";
  sha256 = "0v0z7kjgmcdx9ajlhr9pc1i3qqghd60s02xnlmj4hcxby8k0r8mc";
  buildDepends = [
    contravariant deepseq hybridVectors lens primitive transformers
    vector vectorAlgorithms
  ];
  testDepends = [
    deepseq doctest filepath hlint hybridVectors lens linear mtl
    QuickCheck semigroups simpleReflect testFramework
    testFrameworkQuickcheck2 testFrameworkTh transformers vector
  ];
  patchPhase = ''
    sed -i -e 's|vector-algorithms >=.*|vector-algorithms|' -e 's|QuickCheck.*,|QuickCheck,|' sparse.cabal
  '';
  doCheck = false;
  meta = {
    homepage = "http://github.com/ekmett/sparse";
    description = "A playground of sparse linear algebra primitives using Morton ordering";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
