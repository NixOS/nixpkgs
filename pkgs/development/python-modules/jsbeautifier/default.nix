{
  lib,
  fetchPypi,
  buildPythonPackage,
  editorconfig,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "jsbeautifier";
  version = "2.0.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "jsbeautifier";
    inherit (finalAttrs) version;
    hash = "sha256-lXnU6duqADg/Pv3/TJjIFAu4W6MZOY6Ll82ronq9a6M=";
  };

  build-system = [ setuptools ];
  dependencies = [
    editorconfig
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
