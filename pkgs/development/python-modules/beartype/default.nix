{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, pytestCheckHook
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "beartype";
  version = "0.18.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BIU9eEk/PISwOVbx+gweW4TFMyp2BVndyPLPYUHd95E=";
  };

  nativeBuildInputs = [
    setuptools
  ];

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
