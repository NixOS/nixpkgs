{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:


buildPythonPackage rec {
  pname = "beartype";
  version = "0.9.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "YjYw3CQ7DaWoTw+kFOaqryYT5WetGav+aoHBfqWrYvE=";
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
