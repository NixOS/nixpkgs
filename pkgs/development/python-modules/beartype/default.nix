{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "beartype";
  version = "0.10.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XKG7Zt2WRxVb/bgsoaBmZj93Q/K8h/YABK3fc53vgjY=";
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
