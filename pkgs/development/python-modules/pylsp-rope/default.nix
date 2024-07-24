{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  rope,
  python-lsp-server,

  # checks
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pylsp-rope";
  version = "0.1.16";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "python-rope";
    repo = "pylsp-rope";
    rev = "refs/tags/${version}";
    hash = "sha256-Mr+mWRvOXoy7+SosMae80o0V1jBMn1dEoGmaR/BGHrc=";
  };

  build-system =  [
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
    changelog = "https://github.com/python-rope/pylsp-rope/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
