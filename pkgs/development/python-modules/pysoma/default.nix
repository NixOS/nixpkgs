{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pysoma";
  version = "0.0.12";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-me/A3BIAFJ8CxyiF5RvANdC/NbSYGmcjCFbpybkTxKM=";
  };

  # Project has no test
  doCheck = false;

  pythonImportsCheck = [
    "api"
  ];

  meta = with lib; {
    description = "Python wrapper for the HTTP API provided by SOMA Connect";
    homepage = "https://pypi.org/project/pysoma";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
