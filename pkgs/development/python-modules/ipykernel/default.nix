{ lib
, buildPythonPackage
, fetchPypi
, ipython
, jupyter_client
, traitlets
, tornado
, pythonOlder
, pytest
, nose
}:

buildPythonPackage rec {
  pname = "ipykernel";
  version = "5.1.0";
  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fc0bf97920d454102168ec2008620066878848fcfca06c22b669696212e292f";
  };

  checkInputs = [ pytest nose ];
  propagatedBuildInputs = [ ipython jupyter_client traitlets tornado ];

  checkPhase = ''
    HOME=$(mktemp -d) pytest ipykernel
  '';

  meta = {
    description = "IPython Kernel for Jupyter";
    homepage = http://ipython.org/;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
