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
  version = "2.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-RWA7IJdBD+7o06bvitWo4KDonzRzMYiKl+RvMyzo2VM=";
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
