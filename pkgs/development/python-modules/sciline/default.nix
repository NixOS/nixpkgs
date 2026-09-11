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
  version = "26.8.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "scipp";
    repo = "sciline";
    tag = finalAttrs.version;
    hash = "sha256-FJZjwQGuh8joRPIdA8aQ/MG6GhLVQfp0BtTQkMc4hzI=";
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
