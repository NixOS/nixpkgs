{ lib
, buildPythonPackage
, decorator
, entrypoints
, fetchPypi
, hatchling
, ipykernel
, ipython
, jupyter-client
, psutil
, python-dateutil
, pythonOlder
, pyzmq
, tornado
, tqdm
, traitlets
}:

buildPythonPackage rec {
  pname = "ipyparallel";
  version = "8.6.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-o5ql75VgFwvw6a/typ/wReG5wYMsSTAzd+3Mkc6p+3c=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    decorator
    entrypoints
    ipykernel
    ipython
    jupyter-client
    psutil
    python-dateutil
    pyzmq
    tornado
    tqdm
    traitlets
  ];

  # Requires access to cluster
  doCheck = false;

  pythonImportsCheck = [
    "ipyparallel"
  ];

  meta = with lib;{
    description = "Interactive Parallel Computing with IPython";
    homepage = "https://ipyparallel.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fridh ];
  };
}
