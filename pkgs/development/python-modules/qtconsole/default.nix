{ lib
, buildPythonPackage
, fetchPypi
, nose
, isPy27
, mock
, traitlets
, jupyter_core
, jupyter_client
, pygments
, ipykernel
, pyqt5
}:

buildPythonPackage rec {
  pname = "qtconsole";
  version = "4.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bc1ba15f50c29ed50f1268ad823bb6543be263c18dd093b80495e9df63b003ac";
  };

  buildInputs = [ nose ] ++ lib.optionals isPy27 [mock];
  propagatedBuildInputs = [traitlets jupyter_core jupyter_client pygments ipykernel pyqt5];

  # : cannot connect to X server
  doCheck = false;

  meta = {
    description = "Jupyter Qt console";
    homepage = http://jupyter.org/;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
