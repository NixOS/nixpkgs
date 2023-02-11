{ lib
, fetchPypi
, buildPythonPackage
, editorconfig
, pytestCheckHook
, pythonOlder
, six
}:

buildPythonPackage rec {
  pname = "jsbeautifier";
  version = "1.14.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-d5kyVNsf9vhOtuHXXjtrcsui7yCBOlhbLYHo5ePHE8Y=";
  };

  propagatedBuildInputs = [
    editorconfig
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "jsbeautifier"
  ];

  pytestFlagsArray = [
    "jsbeautifier/tests/testindentation.py"
  ];

  meta = with lib; {
    description = "JavaScript unobfuscator and beautifier";
    homepage = "http://jsbeautifier.org";
    license = licenses.mit;
    maintainers = with maintainers; [ apeyroux ];
  };
}
