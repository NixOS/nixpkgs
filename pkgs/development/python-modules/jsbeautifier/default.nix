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
  version = "1.14.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DVJEhRFE3Ec7HRBEvj3WxW9h/Wnr3B+TuBPYIkJy8G8=";
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
