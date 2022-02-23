{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:


buildPythonPackage rec {
  pname = "beartype";
  version = "0.10.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-7yKOZpOLT0SH2LMGodGaCTi8TvJEthYjCfQjzMjO/HY=";
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
