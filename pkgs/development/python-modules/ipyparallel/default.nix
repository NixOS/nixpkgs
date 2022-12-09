{ lib
, buildPythonPackage
, decorator
, entrypoints
, fetchPypi
, hatchling
, ipykernel
, ipython
, ipython_genutils
, jupyter-client
, packaging
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
  version = "8.4.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Zwu+BXVTgXQuHqARd9xCj/jz6Urx8NVkLJ0Z83yoKJs=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    decorator
    entrypoints
    ipykernel
    ipython
    ipython_genutils
    jupyter-client
    packaging
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
