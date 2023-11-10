{ lib
, black
, buildPythonPackage
, fetchFromGitHub
, hatchling
, pytest
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, ruff
}:

buildPythonPackage rec {
  pname = "pytest-examples";
  version = "0.0.10";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pytest-examples";
    rev = "refs/tags/v${version}";
    hash = "sha256-jCxOGDJlFkMH9VtaaPsE5zt+p3Z/mrVzhdNSI51/nVM=";
  };

  postPatch = ''
    # ruff binary is used directly, the ruff Python package is not needed
    substituteInPlace pytest_examples/lint.py \
      --replace "'ruff'" "'${ruff}/bin/ruff'"
  '';

  pythonRemoveDeps = [
    "ruff"
  ];

  nativeBuildInputs = [
    hatchling
    pythonRelaxDepsHook
  ];

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    black
    ruff
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pytest_examples"
  ];

  disabledTests = [
    # Test fails with latest ruff v0.1.2
    # See https://github.com/pydantic/pytest-examples/issues/26
    "test_ruff_error"
  ];

  meta = with lib; {
    description = "Pytest plugin for testing examples in docstrings and markdown files";
    homepage = "https://github.com/pydantic/pytest-examples";
    changelog = "https://github.com/pydantic/pytest-examples/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
