{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "dbutils";
  version = "3.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit version;
    pname = "DBUtils";
    hash = "sha256-+t65eeFAbcEj4tuZVfMU4NU2DzBOC9bPBHqqX8P99bM=";
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
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
