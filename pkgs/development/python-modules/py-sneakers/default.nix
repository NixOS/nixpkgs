{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "py-sneakers";
  version = "1.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bIhkYTzRe4uM0kbNhbDTr6TiaOEBSiCSkPJKKCivDZY=";
  };

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "py_sneakers"
  ];

  meta = with lib; {
    description = "Library to emulate the Sneakers movie effect";
    homepage = "https://github.com/aenima-x/py-sneakers";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
