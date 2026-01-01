{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
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

  pythonImportsCheck = [ "py_sneakers" ];

<<<<<<< HEAD
  meta = {
    description = "Library to emulate the Sneakers movie effect";
    mainProgram = "py-sneakers";
    homepage = "https://github.com/aenima-x/py-sneakers";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Library to emulate the Sneakers movie effect";
    mainProgram = "py-sneakers";
    homepage = "https://github.com/aenima-x/py-sneakers";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
