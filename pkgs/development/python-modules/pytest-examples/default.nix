{
  lib,
  black,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytest,
  pytestCheckHook,
  pythonOlder,
  ruff,
}:

buildPythonPackage rec {
  pname = "pytest-examples";
  version = "0.0.13";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pytest-examples";
    rev = "refs/tags/v${version}";
    hash = "sha256-R0gSWQEGMkJhkeXImyris2wzqjJ0hC3zO0voEdhWLoY=";
  };

  postPatch = ''
    # ruff binary is used directly, the ruff Python package is not needed
    substituteInPlace pytest_examples/lint.py \
      --replace-fail "'ruff'" "'${lib.getExe ruff}'"
  '';

  pythonRemoveDeps = [ "ruff" ];

  build-system = [
    hatchling
  ];

  buildInputs = [ pytest ];

  dependencies = [ black ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_examples" ];

  meta = {
    description = "Pytest plugin for testing examples in docstrings and markdown files";
    homepage = "https://github.com/pydantic/pytest-examples";
    changelog = "https://github.com/pydantic/pytest-examples/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
