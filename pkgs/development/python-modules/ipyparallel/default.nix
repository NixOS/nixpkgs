{ lib
, buildPythonPackage
, decorator
, entrypoints
, fetchPypi
, hatchling
, ipykernel
, ipython
<<<<<<< HEAD
, jupyter-client
=======
, ipython_genutils
, jupyter-client
, packaging
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  version = "8.6.1";
=======
  version = "8.4.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-o5ql75VgFwvw6a/typ/wReG5wYMsSTAzd+3Mkc6p+3c=";
  };

  # We do not need the jupyterlab build dependency, because we do not need to
  # build any JS components; these are present already in the PyPI artifact.
  #
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '"jupyterlab>=3.0.0,==3.*",' ""
  '';

=======
    hash = "sha256-Zwu+BXVTgXQuHqARd9xCj/jz6Urx8NVkLJ0Z83yoKJs=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    decorator
    entrypoints
    ipykernel
    ipython
<<<<<<< HEAD
    jupyter-client
=======
    ipython_genutils
    jupyter-client
    packaging
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
