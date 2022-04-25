{ lib
, buildPythonPackage
, crc16
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyoppleio";
  version = "1.0.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-q//uJ+2m9S0r+Jsa5Eye90YSw4cKzd04vPHMm89j8kg=";
  };

  propagatedBuildInputs = [
    crc16
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pyoppleio"
  ];

  meta = with lib; {
    description = "Library for interacting with OPPLE lights";
    homepage = "https://github.com/jedmeng/python-oppleio";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
