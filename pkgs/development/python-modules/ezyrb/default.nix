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
  version = "1.3.0.post2212";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mathLab";
    repo = "EZyRB";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-Em7t84fCTYCJfsjLGKhno75PheALhSbLH7z1mfgQ+v4=";
  };

  propagatedBuildInputs = [
    future
    numpy
    scipy
    matplotlib
    scikit-learn
    torch
  ];

  checkInputs = [
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
