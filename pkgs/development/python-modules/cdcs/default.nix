{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, pandas
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  version = "0.1.8";
  pname = "cdcs";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "usnistgov";
    repo = "pycdcs";
    rev = "v${version}";
    sha256 = "sha256-s+COE7hus1J5I8PTdagl7KEK5QFoidjQ3ee46kOWmkE=";
  };

  propagatedBuildInputs = [
    numpy
    pandas
    requests
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "cdcs"
  ];

  meta = with lib; {
    description = "Python client for performing REST calls to configurable data curation system (CDCS) databases";
    homepage = "https://github.com/usnistgov/pycdcs";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
