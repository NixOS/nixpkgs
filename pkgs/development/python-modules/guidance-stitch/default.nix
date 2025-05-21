{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  hatch-jupyter-builder,
  hatch-nodejs-version,
  hatchling,
  jupyterlab,

  # dependencies
  ipywidgets,

  # tests
  nbval,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "guidance-stitch";
  version = "0.1.4";
  pyproject = true;

  src = fetchPypi {
    pname = "guidance_stitch";
    inherit version;
    hash = "sha256-Wthz02C2AU6hzQ+TTGs+sI73ejwHQRCStZXZts0i1+w=";
  };

  build-system = [
    hatch-jupyter-builder
    hatch-nodejs-version
    hatchling
    jupyterlab
  ];

  dependencies = [
    ipywidgets
  ];

  pythonImportsCheck = [ "stitch" ];

  nativeCheckInputs = [
    nbval
    pytest-cov-stub
    pytestCheckHook
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Guidance language for controlling large language models";
    homepage = "https://github.com/guidance-ai/guidance/tree/main/packages/python/stitch";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
