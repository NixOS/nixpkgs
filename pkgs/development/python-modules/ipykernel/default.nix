{ lib
, stdenv
, buildPythonPackage
, callPackage
, fetchPypi
, debugpy
, ipython
, jupyter-client
, tornado
, traitlets
, pythonOlder
}:

buildPythonPackage rec {
  pname = "ipykernel";
  version = "6.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5314690a638f893e2cc3bf3d25042920e9fbb873f7d8263033390264caeb95f4";
  };

  propagatedBuildInputs = [
    debugpy
    ipython
    jupyter-client
    tornado
    traitlets
  ];

  # check in passthru.tests.pytest to escape infinite recursion with ipyparallel
  doCheck = false;

  passthru.tests = {
    pytest = callPackage ./tests.nix { };
  };

  meta = {
    description = "IPython Kernel for Jupyter";
    homepage = "http://ipython.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
