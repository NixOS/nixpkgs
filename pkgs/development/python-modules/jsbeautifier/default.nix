{ lib
, fetchPypi
, buildPythonApplication
, editorconfig
, pytestCheckHook
, pythonOlder
, six
}:

buildPythonApplication rec {
  pname = "jsbeautifier";
  version = "1.14.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cp+mwP6TWyZm8/6tfsV2+RGubo1731ePmy+5K6N3u7M=";
  };

  propagatedBuildInputs = [
    editorconfig
    six
  ];

  checkInputs = [
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
