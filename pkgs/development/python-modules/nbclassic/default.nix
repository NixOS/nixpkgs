{
  lib,
  argon2-cffi,
  buildPythonPackage,
  fetchPypi,
  ipykernel,
  ipython-genutils,
  jinja2,
  jupyter-client,
  jupyter-core,
  jupyter-server,
  nbconvert,
  nbformat,
  nest-asyncio,
  notebook-shim,
  prometheus-client,
  pytest-jupyter,
  pytest-tornasync,
  pytestCheckHook,
  pythonOlder,
  pyzmq,
  send2trash,
  terminado,
  tornado,
  traitlets,
}:

buildPythonPackage rec {
  pname = "nbclassic";
  version = "1.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-d7d7qF+emI+brYXfNFtRTp5kx/DoIpkqsd9KeKxk/B4=";
  };

  propagatedBuildInputs = [
    argon2-cffi
    ipykernel
    ipython-genutils
    jinja2
    jupyter-client
    jupyter-core
    jupyter-server
    nbconvert
    nbformat
    nest-asyncio
    notebook-shim
    prometheus-client
    pyzmq
    send2trash
    terminado
    tornado
    traitlets
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
    maintainers = with maintainers; [ elohmeier ];
  };
}
