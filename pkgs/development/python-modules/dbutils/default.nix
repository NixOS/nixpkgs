{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "dbutils";
  version = "3.0.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit version;
    pname = "DBUtils";
    hash = "sha256-jkhWWxKtK0sfIU3gKU3utLKFePWyq7QNaMKSS2TX4Ac=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dbutils"
  ];

  meta = with lib; {
    description = "Database connections for multi-threaded environments";
    homepage = "https://webwareforpython.github.io/DBUtils/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
