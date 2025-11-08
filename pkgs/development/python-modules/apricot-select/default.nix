{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  apricot-select,
  numba,
  numpy,
  pytestCheckHook,
  pythonOlder,
  scikit-learn,
  scipy,
  setuptools,
  torchvision,
  tqdm,
}:

buildPythonPackage rec {
  pname = "apricot-select";
  version = "0.6.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jmschrei";
    repo = "apricot";
    tag = version;
    hash = "sha256-v9BHFxmlbwXVipPze/nV35YijdFBuka3gAl85AlsffQ=";
  };

  patches = [
    # migrate to pytest, https://github.com/jmschrei/apricot/pull/43
    (fetchpatch2 {
      url = "https://github.com/jmschrei/apricot/commit/ffa5cce97292775c0d6890671a19cacd2294383f.patch?full_index=1";
      hash = "sha256-9A49m4587kAPK/kzZBqMRPwuA40S3HinLXaslYUcWdM=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    numba
    numpy
    scikit-learn
    scipy
    torchvision
    tqdm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "apricot" ];

  disabledTestPaths = [
    # Tests require nose
    "tests/test_optimizers/test_knapsack_facility_location.py"
    "tests/test_optimizers/test_knapsack_feature_based.py"
  ];

  # NOTE: These tests seem to be flaky.
  disabledTests = [
    "test_digits_modular"
    "test_digits_modular_object"
    "test_digits_modular_sparse"
    "test_digits_sqrt_modular"
    "test_digits_sqrt_modular_object"
    "test_digits_sqrt_modular_sparse"
  ];

  # NOTE: Tests are disabled by default because they can run for hours and timeout on Hydra.
  doCheck = false;

  passthru.tests.check = apricot-select.overridePythonAttrs { doCheck = true; };

  meta = with lib; {
    description = "Module for submodular optimization for the purpose of selecting subsets of massive data sets";
    homepage = "https://github.com/jmschrei/apricot";
    changelog = "https://github.com/jmschrei/apricot/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
