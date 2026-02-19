{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "eradicate";
  version = "3.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wemake-services";
    repo = "eradicate";
    tag = version;
    hash = "sha256-D9V9PQ3HVmShmPgTInOJaVmujy1fQyQn6qYn/Pa0kMg=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "eradicate" ];

  enabledTestPaths = [ "test_eradicate.py" ];

  meta = {
    description = "Library to remove commented-out code from Python files";
    mainProgram = "eradicate";
    homepage = "https://github.com/myint/eradicate";
    changelog = "https://github.com/wemake-services/eradicate/releases/tag/${src.tag}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ mmlb ];
  };
}
