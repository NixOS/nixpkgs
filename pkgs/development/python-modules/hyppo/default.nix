{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytestCheckHook
, numba
, numpy
, scikit-learn
, scipy
, matplotlib
, seaborn
}:

buildPythonPackage rec {
  pname = "hyppo";
  version = "0.2.2";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "neurodata";
    repo = pname;
    rev = "v${version}";
    sha256 = "1wrzrppyjq0pc03bn6qcslxzcnwn7fr2z5lm71gfpli5k05i26nr";
  };

  propagatedBuildInputs = [
    numba
    numpy
    scikit-learn
    scipy
  ];

  checkInputs = [ pytestCheckHook matplotlib seaborn ];
  disabledTestPaths = [
    "docs"
    "benchmarks"
    "examples"
  ];

  meta = with lib; {
    homepage = "https://github.com/neurodata/hyppo";
    description = "Indepedence testing in Python";
    license = licenses.asl20;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
