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
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "nbclassic";
  version = "1.3.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TFLaj8iPn3PvUSzDBQkdXOcmvcoZ9E7Wl8tboS3KrTw=";
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

  meta = with lib; {
    description = "Jupyter lab environment notebook server extension";
    homepage = "https://github.com/jupyter/nbclassic";
    license = with licenses; [ bsd3 ];
  };
}
