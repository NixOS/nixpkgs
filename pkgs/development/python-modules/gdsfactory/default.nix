{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit-core,
  pythonRelaxDepsHook,

  # dependencies
  jinja2,
  loguru,
  matplotlib,
  natsort,
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
buildPythonPackage (finalAttrs: {
  pname = "gdsfactory";
  version = "9.32.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gdsfactory";
    repo = "gdsfactory";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uXFH+6uZx+fFo1QfozI/JVomchFlnWx805CwbAj7CPQ=";
  };

  build-system = [
    flit-core
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  dependencies = [
    jinja2
    loguru
    matplotlib
    natsort
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
    "kfactory"
  ];

  # tests require >32GB of RAM
  doCheck = false;

  pythonImportsCheck = [ "gdsfactory" ];

  meta = {
    description = "Python library to generate GDS layouts";
    homepage = "https://github.com/gdsfactory/gdsfactory";
    changelog = "https://github.com/gdsfactory/gdsfactory/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fbeffa ];
  };
})
