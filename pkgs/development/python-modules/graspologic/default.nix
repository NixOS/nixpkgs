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
  version = "1.0.0";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "graspologic";
    rev = "v${version}";
    sha256 = "sha256-mzJ3eFo77gnOh/Vs9u68yFDZW3ilXtcCCwKahKyRRmc=";
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

  checkInputs = [ pytestCheckHook pytest-cov ];
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
