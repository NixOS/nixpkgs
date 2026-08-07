{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  cyclebane,

  # tests
  pytestCheckHook,
  pytest-randomly,
  rich,
  dask,
  graphviz,
  jsonschema,
  numpy,
  pandas,
  pydantic,
}:

buildPythonPackage (finalAttrs: {
  pname = "sciline";
  version = "25.11.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "scipp";
    repo = "sciline";
    tag = finalAttrs.version;
    hash = "sha256-BTdvPAeI7SWV8gNfXVC63YKghZOfJ9eFousOqycpTAw=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    cyclebane
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-randomly
    dask
    graphviz
    jsonschema
    numpy
    pandas
    pydantic
    rich
  ];

  pythonImportsCheck = [
    "sciline"
  ];

  disabledTestPaths = [
    # Causes all tests to abort due to TypeError, see:
    # https://github.com/scipp/sciline/issues/233
    "tests/complex_workflow_test.py"
    # Fails too with a similar TypeError, reported in the above issue.
    "tests/pipeline_test.py::test_subclasses_of_generic_array_provider_defined_with_Scope_work"
  ];

  meta = {
    description = "Build scientific pipelines for your data";
    homepage = "https://scipp.github.io/sciline/";
    changelog = "https://github.com/scipp/sciline/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
})
