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
, notebook
, notebook-shim
, prometheus-client
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
  version = "0.4.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-x02KUA+OBY1GtXakHlvGQHEeEDLPdUHd5fc+pJSX4oM=";
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
    notebook
    notebook-shim
    prometheus-client
    pyzmq
    send2trash
    terminado
    tornado
    traitlets
  ];

  checkInputs = [
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
