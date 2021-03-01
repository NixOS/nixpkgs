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
, qtpy
}:

buildPythonPackage rec {
  pname = "qtconsole";
  version = "5.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4d7dd4eae8a90d0b2b19b31794b30f137238463998989734a3acb8a53b506bab";
  };

  checkInputs = [ nose ] ++ lib.optionals isPy27 [mock];
  propagatedBuildInputs = [traitlets jupyter_core jupyter_client pygments ipykernel pyqt5 qtpy];

  # : cannot connect to X server
  doCheck = false;

  meta = {
    description = "Jupyter Qt console";
    homepage = "https://jupyter.org/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
