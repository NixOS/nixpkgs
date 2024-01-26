{ lib
, buildPythonPackage
, fetchFromGitHub
, nose
, numba
, numpy
, pytestCheckHook
, pythonOlder
, torchvision
, scikit-learn
, scipy
, setuptools
, tqdm
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

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    numba
    numpy
    scipy
    tqdm
  ];

  nativeCheckInputs = [
    nose
    pytestCheckHook
    torchvision
    scikit-learn
  ];

  pythonImportsCheck = [
    "apricot"
  ];

  disabledTestPaths = [
    # Tests require nose
    "tests/test_optimizers/test_knapsack_facility_location.py"
    "tests/test_optimizers/test_knapsack_feature_based.py"
  ];

  meta = with lib; {
    description = "Module for submodular optimization for the purpose of selecting subsets of massive data sets";
    homepage = "https://github.com/jmschrei/apricot";
    changelog = "https://github.com/jmschrei/apricot/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
