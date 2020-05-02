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
  version = "4.7.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8f5ae5571f0e921db9f2d12613ed667c350ee22c7db598d9bbbe143e8533f932";
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
