{ lib
, buildPythonPackage
, fetchFromGitHub
, pandas
, pytestCheckHook
, pythonOlder
, scikit-learn
}:

buildPythonPackage rec {
  pname = "ppscore";
  version = "1.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "8080labs";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-gJStsL8fN17kvXO8EH/NHGIBelPknJzYw5WEvHsFooU=";
  };

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
    license = licenses.mit;
    maintainers = with maintainers; [ evax ];
  };
}
