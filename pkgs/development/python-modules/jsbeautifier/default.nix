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
  version = "1.15.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tErLPokHmZhZmfo4JHtu1XZtin3pErbx/41ByjzRtT8=";
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
