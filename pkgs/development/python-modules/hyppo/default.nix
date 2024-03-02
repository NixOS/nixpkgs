{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytestCheckHook
, autograd
, numba
, numpy
, scikit-learn
, scipy
, matplotlib
, seaborn
}:

buildPythonPackage rec {
  pname = "hyppo";
  version = "0.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "neurodata";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-QRE3oSxTEobTQ/7DzCAUOdjzIZmWUn9bgPmJWj6JuZg=";
  };

  propagatedBuildInputs = [
    autograd
    numba
    numpy
    scikit-learn
    scipy
  ];

  nativeCheckInputs = [ pytestCheckHook matplotlib seaborn ];
  disabledTestPaths = [
    "docs"
    "benchmarks"
    "examples"
  ];

  meta = with lib; {
    homepage = "https://github.com/neurodata/hyppo";
    description = "Python package for multivariate hypothesis testing";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
