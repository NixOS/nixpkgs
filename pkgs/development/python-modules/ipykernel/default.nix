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
  version = "4.8.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dedc199df6a38725c732986dfa606c245fb8fe0fe999b33a0c305b73d80c6774";
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