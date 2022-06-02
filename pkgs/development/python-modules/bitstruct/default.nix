{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "bitstruct";
  version = "8.14.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-04ExvUR7avW49GTEh4eXyHpdnaHJW5NX4HHEJP3l8FU=";
  };

  pythonImportsCheck = [
    "bitstruct"
  ];

  meta = with lib; {
    description = "Python bit pack/unpack package";
    homepage = "https://github.com/eerimoq/bitstruct";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
