{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "parts";
  version = "1.5.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gOPDqXF05bQcG0Kv0+akBrikRr/CfHB9/tM/TJDPHdM=";
  };

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "parts"
  ];

  meta = with lib; {
    description = "Library for common list functions related to partitioning lists";
    homepage = "https://github.com/lapets/parts";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
