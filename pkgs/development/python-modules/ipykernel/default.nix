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
  version = "4.7.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "354986612a38f0555c43d5af2425e2a67506b63b313a0325e38904003b9d977b";
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