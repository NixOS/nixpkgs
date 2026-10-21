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
  version = "26.9.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "scipp";
    repo = "sciline";
    tag = finalAttrs.version;
    hash = "sha256-jXMe1MVPxur5c79MIZB8gyKM471GVyuiCFsxOWB1qzo=";
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

  meta = {
    description = "Build scientific pipelines for your data";
    homepage = "https://scipp.github.io/sciline/";
    changelog = "https://github.com/scipp/sciline/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
})
