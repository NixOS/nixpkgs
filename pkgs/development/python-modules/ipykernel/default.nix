{ lib
, buildPythonPackage
, callPackage
, fetchPypi
, pythonOlder
, argcomplete
, debugpy
, ipython
, jupyter-client
, tornado
, traitlets
}:

buildPythonPackage rec {
  pname = "ipykernel";
  version = "6.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dd27172bccbbcfef952991e49372e4c6fd1c14eed0df05ebd5b4335cb27a81a2";
  };

  propagatedBuildInputs = [
    debugpy
    ipython
    jupyter-client
    tornado
    traitlets
  ] ++ lib.optionals (pythonOlder "3.8") [
    argcomplete
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
