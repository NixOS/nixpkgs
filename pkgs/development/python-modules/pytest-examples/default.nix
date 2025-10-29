{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  hatchling,
  pytest,
  black,
  ruff,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-examples";
  version = "0.0.18";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pytest-examples";
    tag = "v${version}";
    hash = "sha256-ZnDl0B7/oLX6PANrqsWtVJwe4E/+7inCgOpo7oSeZlw=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/pydantic/pytest-examples/pull/65/commits/60ae70d05ee345b38c2d2048d36b4a4545c98b6b.diff";
      hash = "sha256-Rhrg0zVChwwa7Gk+WYrCu44VgUQmxLBeq8pWSF6Nzdo=";
    })
  ];

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

  disabledTestPaths = [
    # assert 1 + 2 == 4
    "tests/test_run_examples.py::test_run_example_ok_fail"
  ];

  meta = {
    description = "Pytest plugin for testing examples in docstrings and markdown files";
    homepage = "https://github.com/pydantic/pytest-examples";
    changelog = "https://github.com/pydantic/pytest-examples/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
