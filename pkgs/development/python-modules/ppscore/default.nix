{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pandas
, pytestCheckHook
, pythonOlder
, scikit-learn
}:

buildPythonPackage rec {
  pname = "ppscore";
  version = "1.3.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "8080labs";
    repo = "ppscore";
    rev = "refs/tags/${version}";
    hash = "sha256-gJStsL8fN17kvXO8EH/NHGIBelPknJzYw5WEvHsFooU=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    pandas
    scikit-learn
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "ppscore"
  ];

  meta = with lib; {
    description = "Python implementation of the Predictive Power Score (PPS)";
    homepage = "https://github.com/8080labs/ppscore/";
    changelog = "https://github.com/8080labs/ppscore/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ evax ];
  };
}
