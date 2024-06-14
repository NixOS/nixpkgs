{
  lib,
  black,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  hatchling,
  pytest,
  pytestCheckHook,
  pythonOlder,
  ruff,
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

  patches = [
    (fetchpatch {
      url = "https://github.com/pydantic/pytest-examples/commit/551ba911713c2859caabc91b664723dd6bc800c5.patch";
      hash = "sha256-Y3OU4fNyLADhBQGwX2jY0gagVV2q2dcn3kJRLUyCtZI=";
    })
    (fetchpatch {
      url = "https://github.com/pydantic/pytest-examples/commit/3bef5d644fe3fdb076270833768e4c6df9148530.patch";
      hash = "sha256-pf+WKzZNqgjbJiblMMLHWk23kjg4W9nm+KBmC8rG8Lw=";
    })
  ];

  postPatch = ''
    # ruff binary is used directly, the ruff Python package is not needed
    substituteInPlace pytest_examples/lint.py \
      --replace "'ruff'" "'${ruff}/bin/ruff'"
  '';

  pythonRemoveDeps = [ "ruff" ];

  nativeBuildInputs = [
    hatchling
  ];

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ black ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_examples" ];

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
