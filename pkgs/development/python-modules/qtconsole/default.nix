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
  version = "4.5.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1nf64wl3ni0q69ihcm5y6zl12mmg7gvkhrb98hbgwv3yb09787mr";
  };

  checkInputs = [ nose ] ++ lib.optionals isPy27 [mock];
  propagatedBuildInputs = [traitlets jupyter_core jupyter_client pygments ipykernel pyqt5];

  # : cannot connect to X server
  doCheck = false;

  meta = {
    description = "Jupyter Qt console";
    homepage = https://jupyter.org/;
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
