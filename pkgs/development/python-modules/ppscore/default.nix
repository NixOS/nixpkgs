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
  version = "unstable-2021-11-25";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "8080labs";
    repo = pname;
    rev = "c9268c16b6305c5c38e2fe2fd84f43d97ec1aaca";
    hash = "sha256-qiogjUgcLFauAMpVf2CKNC27c9xR9q7nY69n8/go1ms=";
  };

  propagatedBuildInputs = [
    pandas
    scikit-learn
  ];

  checkInputs = [
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
