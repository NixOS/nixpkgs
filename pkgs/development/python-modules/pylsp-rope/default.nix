{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  rope,
  python-lsp-server,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pylsp-rope";
  version = "0.1.18";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-rope";
    repo = "pylsp-rope";
    tag = finalAttrs.version;
    hash = "sha256-WqjRHSsCMdsZ0uWcfHgx8O/LHOR3blW8yVKEQZtfvqs=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    rope
    python-lsp-server
  ];

  pythonImportsCheck = [ "pylsp_rope" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Extended refactoring capabilities for Python LSP Server using Rope";
    homepage = "https://github.com/python-rope/pylsp-rope";
    changelog = "https://github.com/python-rope/pylsp-rope/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
