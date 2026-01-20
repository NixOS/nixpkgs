{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  version = "5.2";
  pname = "roman";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "roman";
    tag = finalAttrs.version;
    hash = "sha256-ZtwHlS3V18EqDXJxTTwfUdtOvyQg9GbSArV7sOs1b38=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "roman" ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "src/tests.py" ];

  meta = {
    description = "Integer to Roman numerals converter";
    changelog = "https://github.com/zopefoundation/roman/blob/${finalAttrs.version}/CHANGES.rst";
    homepage = "https://pypi.python.org/pypi/roman";
    license = lib.licenses.psfl;
    maintainers = with lib.maintainers; [ sigmanificient ];
    mainProgram = "roman";
  };
})
