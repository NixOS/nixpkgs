{ lib
, buildPythonPackage
, fetchPypi
, ipykernel
, jupyter_core
, jupyter-client
, pygments
, pyqt5
, pytestCheckHook
, pythonOlder
, pyzmq
, qtpy
, traitlets
}:

buildPythonPackage rec {
  pname = "qtconsole";
  version = "5.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-V3SOov0mMgoLd626IBMc+7E4GMfJbYP6/LEQ/1X1izU=";
  };

  propagatedBuildInputs = [
    ipykernel
    jupyter_core
    jupyter-client
    pygments
    pyqt5
    pyzmq
    qtpy
    traitlets
  ];

  checkInputs = [
    pytestCheckHook
  ];

  # : cannot connect to X server
  doCheck = false;

  pythonImportsCheck = [
    "qtconsole"
  ];

  meta = with lib; {
    description = "Jupyter Qt console";
    homepage = "https://qtconsole.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fridh ];
    platforms = platforms.unix;
  };
}
