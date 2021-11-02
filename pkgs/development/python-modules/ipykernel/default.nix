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
  version = "6.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "df3355e5eec23126bc89767a676c5f0abfc7f4c3497d118c592b83b316e8c0cd";
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
