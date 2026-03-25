{
  lib,
  aiofiles,
  buildPythonPackage,
  colorama,
  fetchFromGitHub,
  git,
  jsonschema,
  pdm-backend,
  pytest-gitconfig,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "griffe";
  version = "1.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mkdocstrings";
    repo = "griffe";
    tag = version;
    hash = "sha256-AMMTAqsJfj2MltTgAxfvjUTVzi+ZFmx+J9pzhMp28Z4=";
  };

  build-system = [ pdm-backend ];

  dependencies = [ colorama ];

  nativeCheckInputs = [
    git
    jsonschema
    pytest-gitconfig
    pytestCheckHook
  ];

  optional-dependencies = {
    async = [ aiofiles ];
  };

  pythonImportsCheck = [ "griffe" ];

  disabledTestPaths = [
    # Circular dependencies
    "tests/test_api.py"
  ];

  meta = {
    description = "Signatures for entire Python programs";
    homepage = "https://github.com/mkdocstrings/griffe";
    changelog = "https://github.com/mkdocstrings/griffe/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "griffe";
  };
}
