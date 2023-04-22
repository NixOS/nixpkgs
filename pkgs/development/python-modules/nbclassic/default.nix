{ lib
, argon2-cffi
, buildPythonPackage
, fetchPypi
, ipykernel
, ipython_genutils
, jinja2
, jupyter-client
, jupyter-core
, jupyter-server
, nbconvert
, nbformat
, nest-asyncio
, notebook-shim
, prometheus-client
, pytest-jupyter
, pytest-tornasync
, pytestCheckHook
, pythonOlder
, pyzmq
, send2trash
, terminado
, tornado
, traitlets
}:

buildPythonPackage rec {
  pname = "nbclassic";
  version = "0.5.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QPEbvMWeiVbD1e8TLeyOWoU+iT7Pgx55HVTaDYpQ150=";
  };

  propagatedBuildInputs = [
    argon2-cffi
    ipykernel
    ipython_genutils
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

  pythonImportsCheck = [
    "nbclassic"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Jupyter lab environment notebook server extension";
    homepage = "https://github.com/jupyterlab/nbclassic";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ elohmeier ];
  };
}
