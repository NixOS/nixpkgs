{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytest,
  black,
  ruff,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-examples";
  version = "0.0.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pytest-examples";
    tag = "v${version}";
    hash = "sha256-FLcvPa3vBldNINFM5hOraczrZCjSmlrEqkBj+f/sU1k=";
  };

  build-system = [
    hatchling
  ];

  buildInputs = [ pytest ];

  dependencies = [
    black
    ruff
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_examples" ];

  disabledTests = [
    # Fails with AssertionError because formatting is different than expected
    "test_black_error"
    "test_black_error_dot_space"
    "test_black_error_multiline"
  ];

  meta = {
    description = "Pytest plugin for testing examples in docstrings and markdown files";
    homepage = "https://github.com/pydantic/pytest-examples";
    changelog = "https://github.com/pydantic/pytest-examples/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
