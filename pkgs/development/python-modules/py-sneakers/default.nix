{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "py-sneakers";
  version = "1.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bIhkYTzRe4uM0kbNhbDTr6TiaOEBSiCSkPJKKCivDZY=";
  };

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "py_sneakers" ];

  meta = {
    description = "Library to emulate the Sneakers movie effect";
    mainProgram = "py-sneakers";
    homepage = "https://github.com/aenima-x/py-sneakers";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
