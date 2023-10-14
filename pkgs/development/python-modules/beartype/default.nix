{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "beartype";
  version = "0.14.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VG5ujc3aHW2fkG6k6xUYqgHJxfWkQOSVkXstr1PL1Zg=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "beartype"
  ];

  meta = with lib; {
    description = "Fast runtime type checking for Python";
    homepage = "https://github.com/beartype/beartype";
    changelog = "https://github.com/beartype/beartype/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
