{
  lib,
  fetchPypi,
  buildPythonPackage,
  editorconfig,
  pytestCheckHook,
  pythonOlder,
  six,
}:

buildPythonPackage rec {
  pname = "jsbeautifier";
  version = "1.15.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-W7GNnvuTMdglc1+8U2DujxqsXlJ4AEKAOUOqf4VPdZI=";
  };

  propagatedBuildInputs = [
    editorconfig
    six
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "jsbeautifier" ];

  enabledTestPaths = [ "jsbeautifier/tests/testindentation.py" ];

  meta = with lib; {
    description = "JavaScript unobfuscator and beautifier";
    mainProgram = "js-beautify";
    homepage = "http://jsbeautifier.org";
    changelog = "https://github.com/beautify-web/js-beautify/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ apeyroux ];
  };
}
