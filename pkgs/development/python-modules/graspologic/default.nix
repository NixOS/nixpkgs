{
  lib,
  buildPythonPackage,
  isPy27,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  pytest-cov,
  hyppo,
  matplotlib,
  networkx,
  numpy,
  scikit-learn,
  scipy,
  seaborn,
}:

buildPythonPackage rec {
  pname = "graspologic";
  version = "3.4.1";
  pyproject = true;

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "graspologic";
    rev = "refs/tags/v${version}";
    hash = "sha256-taX/4/uCQXW7yFykVHY78hJIGThEIycHwrEOZ3h1LPY=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    hyppo
    matplotlib
    networkx
    numpy
    scikit-learn
    scipy
    seaborn
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov
  ];
  pytestFlagsArray = [
    "tests"
    "--ignore=docs"
    "--ignore=tests/test_sklearn.py"
  ];
  disabledTests = [ "gridplot_outputs" ];

  meta = with lib; {
    homepage = "https://graspologic.readthedocs.io";
    description = "Package for graph statistical algorithms";
    license = licenses.asl20; # changing to `licenses.mit` in next release
    maintainers = with maintainers; [ bcdarwin ];
    # graspologic-native is not available
    broken = true;
  };
}
