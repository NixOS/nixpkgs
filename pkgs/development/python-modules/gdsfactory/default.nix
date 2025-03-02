{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  flit-core,
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
  # tests
  jsondiff,
  jsonschema,
  pytest-regressions,
}:
buildPythonPackage rec {
  pname = "gdsfactory";
  version = "8.18.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gdsfactory";
    repo = "gdsfactory";
    rev = "v${version}";
    hash = "sha256-wDz8QpRgu40FB8+otnGsHVn2e6/SWXIZgA1aeMqMhPQ=";
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
  ];

  nativeCheckInputs = [
    jsondiff
    jsonschema
    pytestCheckHook
    pytest-regressions
  ];

  pythonRelaxDeps = [
    "pydantic"
    "trimesh"
  ];

  # tests require >32GB of RAM
  doCheck = false;

  pythonImportsCheck = [ "gdsfactory" ];

  meta = with lib; {
    description = "Python library to generate GDS layouts";
    homepage = "https://github.com/gdsfactory/gdsfactory";
    license = licenses.mit;
    maintainers = with maintainers; [ fbeffa ];
  };
}
