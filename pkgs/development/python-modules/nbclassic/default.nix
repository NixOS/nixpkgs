{
  lib,
  buildPythonPackage,
  fetchPypi,
  babel,
  ipykernel,
  ipython-genutils,
  jupyter-packaging,
  jupyter-server,
  nest-asyncio,
  notebook-shim,
  pytest-jupyter,
  pytest-tornasync,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "nbclassic";
  version = "1.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-c27FBIOlRIWXHbITvpIH405R/BRMeDQ2JbaZF0I2RLo=";
  };

  build-system = [
    babel
    jupyter-packaging
    jupyter-server
  ];

  dependencies = [
    ipykernel
    ipython-genutils
    nest-asyncio
    notebook-shim
  ];

  nativeCheckInputs = [
    pytest-jupyter
    pytest-tornasync
    pytestCheckHook
  ];

  pythonImportsCheck = [ "nbclassic" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Jupyter lab environment notebook server extension";
    homepage = "https://github.com/jupyter/nbclassic";
    license = with lib.licenses; [ bsd3 ];
  };
}
