{
  lib,
  aiofiles,
  buildPythonPackage,
  colorama,
  fetchFromGitHub,
  git,
  jsonschema,
  pdm-backend,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "griffe";
  version = "1.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mkdocstrings";
    repo = "griffe";
    tag = version;
    hash = "sha256-kP3n9NJ9dW8S2zEMAHgtWbJUQiYt7NadgrR7DD67+Vs=";
  };

  build-system = [ pdm-backend ];

  dependencies = [ colorama ];

  nativeCheckInputs = [
    git
    jsonschema
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
