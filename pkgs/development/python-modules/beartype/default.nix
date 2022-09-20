{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "beartype";
  version = "0.11.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OFS1Dqqpi7iUkL5X5zxpx3eg8wRXTnBDrH2pisanNaY=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "beartype"
  ];

  meta = with lib; {
    description = "Fast runtime type checking for Python";
    homepage = "https://github.com/beartype/beartype";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
