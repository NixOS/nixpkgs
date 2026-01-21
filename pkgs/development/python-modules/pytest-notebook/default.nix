{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit-core,

  # dependencies
  attrs,
  jsonschema,
  nbclient,
  nbdime,
  nbformat,

  # buildInputs
  pytest,

  # tests
  black,
  ipykernel,
  pytest-cov-stub,
  pytest-regressions,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
  pythonAtLeast,
}:

buildPythonPackage rec {
  pname = "pytest-notebook";
  version = "0.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chrisjsewell";
    repo = "pytest-notebook";
    tag = "v${version}";
    hash = "sha256-LoK0wb7rAbVbgyURCbSfckWvJDef3tPY+7V4YU1IBRU=";
  };

  postPatch = ''
    # we disable the tests relying on coverage for unrelated reasons
    substituteInPlace tests/test_execution.py \
      --replace-fail "from coverage import CoverageData" ""
  '';

  build-system = [
    flit-core
  ];

  pythonRelaxDeps = [
    "attrs"
    "nbclient"
  ];

  dependencies = [
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
    ipykernel
    pytest-cov-stub
    pytest-regressions
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # AssertionError: FILES DIFFER:
    "test_diff_to_string"

    # pytest_notebook.execution.CoverageError: An error occurred while executing coverage start-up
    # TypeError: expected str, bytes or os.PathLike object, not NoneType
    "test_execute_notebook_with_coverage"
    "test_regression_coverage"

    # pytest_notebook.nb_regression.NBRegressionError
    "test_regression_regex_replace_pass"
  ]
  ++ lib.optionals (pythonAtLeast "3.13") [
    # AssertionError: FILES DIFFER:
    "test_documentation"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    changelog = "https://github.com/chrisjsewell/pytest-notebook/blob/${src.tag}/docs/source/changelog.md";
    description = "Pytest plugin for regression testing and regenerating Jupyter Notebooks";
    homepage = "https://github.com/chrisjsewell/pytest-notebook";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
