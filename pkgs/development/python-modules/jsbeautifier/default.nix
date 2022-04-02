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
  version = "1.14.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PskybkfTilQ5W97/h2lWakcnWOcLnhG6fMVs/spqm/Y=";
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
