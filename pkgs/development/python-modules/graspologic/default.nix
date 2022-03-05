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
  version = "0.3.1";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "graspologic";
    rev = "v${version}";
    sha256 = "07dmfb1aplha01d22b41js7634dac4v28pv1l3bzssqhi4yyds7h";
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
  };
}
