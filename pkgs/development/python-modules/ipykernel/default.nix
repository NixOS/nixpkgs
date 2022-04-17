{ lib
, buildPythonPackage
, callPackage
, fetchPypi
, pythonOlder
, ipython
, jupyter-client
, packaging
, psutil
, tornado
, traitlets
}:

buildPythonPackage rec {
  pname = "ipykernel";
  version = "6.12.1";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-CGj1VhcpreREAR+Mp9NQLcnyf39E4g8dX+5+Hytxg6E=";
  };

  # debugpy is optional, see https://github.com/ipython/ipykernel/pull/767
  postPatch = ''
    sed -i "/debugpy/d" setup.py
  '';

  propagatedBuildInputs = [
    ipython
    jupyter-client
    packaging
    psutil
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
