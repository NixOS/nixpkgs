{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pythonRelaxDepsHook,
  attrs,
  jsonschema,
  nbclient,
  nbdime,
  nbformat,
  pytest,
  black,
  coverage,
  ipykernel,
  pytest-cov,
  pytest-regressions,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-notebook";
  version = "0.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chrisjsewell";
    repo = "pytest-notebook";
    rev = "refs/tags/v${version}";
    hash = "sha256-LoK0wb7rAbVbgyURCbSfckWvJDef3tPY+7V4YU1IBRU=";
  };

  nativeBuildInputs = [
    flit-core
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "attrs"
    "nbclient"
  ];

  propagatedBuildInputs = [
    attrs
    jsonschema
    nbclient
    nbdime
    nbformat
  ];

  buildInputs = [ pytest ];

  pythonImportsCheck = [ "pytest_notebook" ];

  nativeCheckInputs = [
    black
    coverage
    ipykernel
    pytest-cov
    pytest-regressions
    pytestCheckHook
  ];

  preCheck = ''
    export HOME="$TEMP"
  '';

  disabledTests = [
    "test_diff_to_string"
    "test_execute_notebook_with_coverage"
    "test_regression_coverage"
    "test_collection"
    "test_setup_with_skip_meta"
    "test_run_fail"
    "test_run_pass_with_meta"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    changelog = "https://github.com/chrisjsewell/pytest-notebook/blob/${src.rev}/docs/source/changelog.md";
    description = "Pytest plugin for regression testing and regenerating Jupyter Notebooks";
    homepage = "https://github.com/chrisjsewell/pytest-notebook";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
