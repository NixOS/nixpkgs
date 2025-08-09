{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  hatchling,
  hatch-vcs,

  # dependencies
  aiohttp,
  backoff,
  bokeh,
  boto3,
  click,
  dask,
  distributed,
  fabric,
  filelock,
  gilknocker,
  httpx,
  importlib-metadata,
  invoke,
  ipywidgets,
  jmespath,
  jsondiff,
  paramiko,
  pip,
  pip-requirements-parser,
  prometheus-client,
  rich,
  toml,
  typing-extensions,
  wheel,

  # tests
  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "coiled";
  version = "1.116.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OBaGd9aC1TGtVeQ5K7iI2sWuBV0wG9Jt5sN92EMvi9M=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    aiohttp
    backoff
    bokeh
    boto3
    click
    dask
    distributed
    fabric
    filelock
    gilknocker
    httpx
    importlib-metadata
    invoke
    ipywidgets
    jmespath
    jsondiff
    paramiko
    pip
    pip-requirements-parser
    prometheus-client
    rich
    toml
    typing-extensions
    wheel
  ];

  pythonImportsCheck = [ "coiled" ];

  nativeCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "Python client for coiled.io dask clusters";
    homepage = "https://www.coiled.io/";
    license = lib.licenses.elastic20;
    maintainers = with lib.maintainers; [ daspk04 ];
    mainProgram = "coiled";
  };
}
