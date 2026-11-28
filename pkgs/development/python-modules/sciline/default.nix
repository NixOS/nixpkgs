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
  version = "26.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scipp";
    repo = "sciline";
    tag = finalAttrs.version;
    hash = "sha256-Y65e1e53dao7UwxmP42WSEcsLtGV8YV8ueEKsE7IjfE=";
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
