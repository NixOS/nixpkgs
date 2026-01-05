{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  buildPythonPackage,
  pytestCheckHook,
  setuptools,
  matplotlib,
  numpy,
  packaging,
  torch,
  tqdm,
  flask,
  flask-compress,
  parameterized,
  scikit-learn,
}:

buildPythonPackage rec {
  pname = "captum";
  version = "0.8.0";
  pyproject = true;

  build-system = [ setuptools ];

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "captum";
    tag = "v${version}";
    hash = "sha256-WuKbMYZPHWaTYYhVseSSkwXQk9LBzGuWfmneDw9V2hg=";
  };

  dependencies = [
    matplotlib
    numpy
    packaging
    torch
    tqdm
  ];

  pythonRelaxDeps = [
    "numpy"
  ];

  pythonImportsCheck = [ "captum" ];

  nativeCheckInputs = [
    pytestCheckHook
    flask
    flask-compress
    parameterized
    scikit-learn
  ];

  disabledTestPaths =
    lib.optionals stdenv.hostPlatform.isDarwin [
      # These tests may fail if multiple builds run them at the same time due
      # to hardcoded port number used for rendezvous
      "tests/attr/test_data_parallel.py"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
      # Issue reported upstream at https://github.com/pytorch/captum/issues/1447
      "tests/concept/test_tcav.py"
    ];

  disabledTests = [
    # Failing tests
    "test_softmax_classification_batch_zero_baseline"
    "test_tracin_identity_regression_9_check_idx_none_ArnoldiInfluenceFunction"
  ];

  meta = {
    description = "Model interpretability and understanding for PyTorch";
    homepage = "https://github.com/pytorch/captum";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
