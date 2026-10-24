{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pyflakes,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "autoflake";
  version = "2.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = "autoflake";
    tag = "v${version}";
    hash = "sha256-Th2MyC6Yu+OLF7WZCG1e5VQqBIGz6Eaxx2dTaEpqTtA=";
  };

  build-system = [ hatchling ];

  dependencies = [ pyflakes ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "autoflake" ];

  enabledTestPaths = [
    "test_autoflake.py"
    "test_fuzz.py"
  ];

  meta = {
    description = "Tool to remove unused imports and unused variables";
    homepage = "https://github.com/PyCQA/autoflake";
    changelog = "https://github.com/PyCQA/autoflake/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yuriaisaka ];
    mainProgram = "autoflake";
  };
}
