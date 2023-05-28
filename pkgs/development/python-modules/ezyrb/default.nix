{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, future
, numpy
, scipy
, matplotlib
, scikit-learn
, torch
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "ezyrb";
  version = "1.3.0.post2305";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mathLab";
    repo = "EZyRB";
    rev = "refs/tags/v${version}";
    hash = "sha256-uYwLz5NY+8lO8hZnAhqv+5PlcCSm6OOFWra47pwQhxg=";
  };

  propagatedBuildInputs = [
    future
    numpy
    scipy
    matplotlib
    scikit-learn
    torch
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "ezyrb"
  ];

  disabledTestPaths = [
    # Exclude long tests
    "tests/test_podae.py"
  ];

  meta = with lib; {
    description = "Easy Reduced Basis method";
    homepage = "https://mathlab.github.io/EZyRB/";
    downloadPage = "https://github.com/mathLab/EZyRB/releases";
    license = licenses.mit;
    maintainers = with maintainers; [ yl3dy ];
  };
}
