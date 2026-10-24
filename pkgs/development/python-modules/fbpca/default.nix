{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # dependencies
  numpy,
  scipy,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "fbpca";
  version = "1.0";
  pyproject = true;
  __structuredAttrs = true;

  # The GitHub repository (archived) has no tags
  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-FQZ3ZCR5Zj8xf9u14G2rP5hyHPcDG7SoQRPXpjHEctE=";
  };

  # Recent scipy versions keep the product of dia_matrix objects as a (non-subscriptable)
  # dia_matrix in a test helper
  postPatch = ''
    substituteInPlace fbpca.py \
      --replace-fail \
        "A = A[np.random.permutation(m), :]" \
        "A = A.tocsr()[np.random.permutation(m), :]"
  '';

  build-system = [ setuptools ];

  dependencies = [
    numpy
    scipy
  ];

  pythonImportsCheck = [ "fbpca" ];

  nativeCheckInputs = [ pytestCheckHook ];

  # The unittest test cases live in the module itself
  enabledTestPaths = [ "fbpca.py" ];

  meta = {
    description = "Fast computations of PCA/SVD/eigendecompositions via randomized methods";
    homepage = "https://github.com/facebookarchive/fbpca";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
