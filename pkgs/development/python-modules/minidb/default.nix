{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "minidb";
  version = "2.0.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "thp";
    repo = "minidb";
    rev = version;
    hash = "sha256-H7W+GBapT9uJgbPlARp4ZLKTN7hZlF/FbNo7rObqDM4=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "minidb"
  ];

  meta = with lib; {
    description = "SQLite3-based store for Python objects";
    homepage = "https://thp.io/2010/minidb/";
    license = licenses.isc;
    maintainers = with maintainers; [ tv ];
  };
}

