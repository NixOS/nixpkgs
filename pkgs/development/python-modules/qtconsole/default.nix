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
  version = "4.3.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2821ccf85853b83e4958521f82e36325208787eaf79b19b83905a99cc41aa209";
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
