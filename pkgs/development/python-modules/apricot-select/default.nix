{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numba,
  numpy,
  pynose,
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
    rev = "refs/tags/${version}";
    hash = "sha256-v9BHFxmlbwXVipPze/nV35YijdFBuka3gAl85AlsffQ=";
  };

  postPatch = ''
    sed -i '/"nose"/d' setup.py
  '';

  build-system = [ setuptools ];

  dependencies = [
    numba
    numpy
    scikit-learn
    scipy
    torchvision
    tqdm
  ];

  nativeCheckInputs = [
    pynose
    pytestCheckHook
  ];

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

  meta = with lib; {
    description = "Module for submodular optimization for the purpose of selecting subsets of massive data sets";
    homepage = "https://github.com/jmschrei/apricot";
    changelog = "https://github.com/jmschrei/apricot/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
