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
  version = "4.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1yihnxya9kll24fp4a929mria930i9r20kx43sjjwh92gcb2k9gs";
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
