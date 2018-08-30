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
  version = "4.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7870b19e6a6b0ab3acc09ee65463c0ca7568b3a01a6902d7c4e1ed2c4fc4e176";
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
