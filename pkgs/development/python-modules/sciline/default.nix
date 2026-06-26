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

  meta = {
    description = "Build scientific pipelines for your data";
    homepage = "https://scipp.github.io/sciline/";
    changelog = "https://github.com/scipp/sciline/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
})
