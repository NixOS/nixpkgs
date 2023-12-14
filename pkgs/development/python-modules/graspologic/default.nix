{ lib
, buildPythonPackage
, isPy27
, fetchFromGitHub
, pytestCheckHook
, pytest-cov
, hyppo
, matplotlib
, networkx
, numpy
, scikit-learn
, scipy
, seaborn
}:

buildPythonPackage rec {
  pname = "graspologic";
  version = "3.2.0";
  format = "setuptools";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "graspologic";
    rev = "refs/tags/v${version}";
    hash = "sha256-yXhEI/8qm526D+Ehqqfb+j+sbbh83Q4OWC+UM7cgCjU=";
  };

  propagatedBuildInputs = [
    hyppo
    matplotlib
    networkx
    numpy
    scikit-learn
    scipy
    seaborn
  ];

  nativeCheckInputs = [ pytestCheckHook pytest-cov ];
  pytestFlagsArray = [ "tests" "--ignore=docs" "--ignore=tests/test_sklearn.py" ];
  disabledTests = [ "gridplot_outputs" ];

  meta = with lib; {
    homepage = "https://graspologic.readthedocs.io";
    description = "A package for graph statistical algorithms";
    license = licenses.asl20;  # changing to `licenses.mit` in next release
    maintainers = with maintainers; [ bcdarwin ];
    # graspologic-native is not available
    broken = true;
  };
}
