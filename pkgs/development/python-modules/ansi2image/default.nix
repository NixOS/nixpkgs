{
  lib,
  buildPythonPackage,
  colorama,
  fetchFromGitHub,
  pillow,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "ansi2image";
  version = "0.1.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "helviojunior";
    repo = "ansi2image";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GWrVo1WJux+ATvG5F9J4WMDlI0XAeTpQg7NrkN1P4Co=";
  };

  build-system = [ setuptools ];

  dependencies = [
    colorama
    pillow
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ansi2image" ];

  enabledTestPaths = [ "tests/tests.py" ];

  meta = {
    description = "Module to convert ANSI text to an image";
    mainProgram = "ansi2image";
    homepage = "https://github.com/helviojunior/ansi2image";
    changelog = "https://github.com/helviojunior/ansi2image/blob/${finalAttrs.version}/CHANGELOG";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
