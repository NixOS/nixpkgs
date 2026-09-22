{
  lib,
  fetchPypi,
  buildPythonPackage,
  editorconfig,
  pytestCheckHook,
  six,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "jsbeautifier";
  version = "1.15.4";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-W7GNnvuTMdglc1+8U2DujxqsXlJ4AEKAOUOqf4VPdZI=";
  };

  build-system = [ setuptools ];
  dependencies = [
    editorconfig
    six
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "jsbeautifier" ];

  enabledTestPaths = [ "jsbeautifier/tests/testindentation.py" ];

  meta = {
    description = "JavaScript unobfuscator and beautifier";
    mainProgram = "js-beautify";
    homepage = "http://jsbeautifier.org";
    changelog = "https://github.com/beautify-web/js-beautify/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ apeyroux ];
  };
})
