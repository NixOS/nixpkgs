{ lib
, buildPythonPackage
, fetchPypi
, nose
, isPy27
, mock
, ipython
, jupyter-client
, pexpect
, traitlets
, tornado
}:

buildPythonPackage rec {
  pname = "ipykernel";
  version = "4.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "eeb74b2bcfe0ced5a7900361f98fa1171288aa47ed4b522efe5acb167c6cf5fb";
  };

  checkInputs = [ nose ] ++ lib.optional isPy27 mock;
  propagatedBuildInputs = [
    ipython
    jupyter-client
    pexpect
    traitlets
    tornado
  ];

  # Tests require backends.
  # I don't want to add all supported backends as propagatedBuildInputs
  doCheck = false;

  meta = {
    description = "IPython Kernel for Jupyter";
    homepage = "http://ipython.org/";
    license = lib.licenses.bsd3;
  };
}
