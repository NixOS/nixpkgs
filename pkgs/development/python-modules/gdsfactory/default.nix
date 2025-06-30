{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit-core,

  # dependencies
  jinja2,
  loguru,
  matplotlib,
  numpy,
  orjson,
  pandas,
  pydantic,
  pydantic-settings,
  pydantic-extra-types,
  pyyaml,
  qrcode,
  rectpack,
  rich,
  scipy,
  shapely,
  toolz,
  types-pyyaml,
  typer,
  kfactory,
  watchdog,
  freetype-py,
  mapbox-earcut,
  networkx,
  scikit-image,
  trimesh,
  ipykernel,
  attrs,
  graphviz,
  pyglet,
  typing-extensions,

  # tests
  jsondiff,
  jsonschema,
  pytest-regressions,
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "gdsfactory";
  version = "9.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gdsfactory";
    repo = "gdsfactory";
    tag = "v${version}";
    hash = "sha256-BcFEMcHt0qUQ0hTLSznuIH37rAk+10JGrPdrhE/sTfU=";
  };

  build-system = [ flit-core ];

  dependencies = [
    jinja2
    loguru
    matplotlib
    numpy
    orjson
    pandas
    pydantic
    pydantic-settings
    pydantic-extra-types
    pyyaml
    qrcode
    rectpack
    rich
    scipy
    shapely
    toolz
    types-pyyaml
    typer
    kfactory
    watchdog
    freetype-py
    mapbox-earcut
    networkx
    scikit-image
    trimesh
    ipykernel
    attrs
    graphviz
    pyglet
    typing-extensions
  ];

  nativeCheckInputs = [
    jsondiff
    jsonschema
    pytest-regressions
    pytestCheckHook
  ];

  pythonRelaxDeps = [
    "pydantic"
    "trimesh"
  ];

  # tests require >32GB of RAM
  doCheck = false;

  pythonImportsCheck = [ "gdsfactory" ];

  meta = {
    description = "Python library to generate GDS layouts";
    homepage = "https://github.com/gdsfactory/gdsfactory";
    changelog = "https://github.com/gdsfactory/gdsfactory/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fbeffa ];
  };
}
