{ lib
, buildPythonPackage
, fetchPypi
, nose
, isPy27
, mock
, traitlets
, jupyter_core
, jupyter-client
, pygments
, ipykernel
, pyqt5
, qtpy
}:

buildPythonPackage rec {
  pname = "qtconsole";
  version = "5.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8f9db97b27782184efd0a0f2d57ea3bd852d053747a2e442a9011329c082976d";
  };

  checkInputs = [ nose ] ++ lib.optionals isPy27 [mock];
  propagatedBuildInputs = [traitlets jupyter_core jupyter-client pygments ipykernel pyqt5 qtpy];

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
