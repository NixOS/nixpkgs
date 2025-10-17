{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pytest-plus";
  version = "0.8.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = "pytest-plus";
    tag = "v${version}";
    hash = "sha256-XlEtekOASIjZretTbQAf0eyQN6qZ9c6zI1ESss/hxfI=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "test/" ];

  pythonImportsCheck = [ "pytest_plus" ];

  meta = with lib; {
    description = "pytest-plus adds new features to pytest";
    homepage = "https://github.com/pytest-dev/pytest-plus";
    changelog = "https://github.com/pytest-dev/pytest-plus/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ robsliwi ];
  };
}
