{ lib
, stdenv
, buildPythonPackage
, callPackage
, fetchPypi
, debugpy
, ipython
, jupyter_client
, tornado
, traitlets
, pythonOlder
}:

buildPythonPackage rec {
  pname = "ipykernel";
  version = "6.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4439459f171d77f35b7f7e72dace5d7c2dd10a5c9e2c22b173ad9048fbfe7656";
  };

  propagatedBuildInputs = [
    debugpy
    ipython
    jupyter_client
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
