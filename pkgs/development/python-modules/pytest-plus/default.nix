{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytest-plus";
  version = "0.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = "pytest-plus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XlEtekOASIjZretTbQAf0eyQN6qZ9c6zI1ESss/hxfI=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "test/" ];

  pythonImportsCheck = [ "pytest_plus" ];

  meta = {
    description = "pytest-plus adds new features to pytest";
    homepage = "https://github.com/pytest-dev/pytest-plus";
    changelog = "https://github.com/pytest-dev/pytest-plus/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ robsliwi ];
  };
})
