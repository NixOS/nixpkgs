{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "beartype";
  version = "0.15.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Kvao2KcmfM99Jx4aO9kIr7wCXSoJqlESNWfX17N0ON8=";
  };

  nativeCheckInputs = [
    pytestCheckHook
    typing-extensions
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
