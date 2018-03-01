{ lib
, buildPythonPackage
, fetchPypi
, nose
, isPy27
, mock
, ipython
, jupyter_client
, pexpect
, traitlets
, tornado
}:

buildPythonPackage rec {
  pname = "ipykernel";
  version = "4.8.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fe2837622a4121cbe42b354db1e2ab46c91e807ffcb92f4c2cfd323a75f8737f";
  };

  buildInputs = [ nose ] ++ lib.optional isPy27 mock;
  propagatedBuildInputs = [
    ipython
    jupyter_client
    pexpect
    traitlets
    tornado
  ];

  # Tests require backends.
  # I don't want to add all supported backends as propagatedBuildInputs
  doCheck = false;

  meta = {
    description = "IPython Kernel for Jupyter";
    homepage = http://ipython.org/;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}