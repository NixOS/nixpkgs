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
  version = "5.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bb3b9f0d674055e627c1097779c0d5e028176706d3b6be39cf52235f6ddcc88e";
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
