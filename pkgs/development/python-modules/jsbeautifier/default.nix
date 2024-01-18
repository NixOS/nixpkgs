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
  version = "1.14.11";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-a2Mlgepg3RwTPNJaSK0Ye0uR9SZiPEsPtUQ++AUlBQU=";
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
    changelog = "https://github.com/beautify-web/js-beautify/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ apeyroux ];
  };
}
